package com.bitsyrup.rugrat.common;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Administrator;

import java.net.MalformedURLException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import java.util.HashMap;
import java.util.List;

public class auth {

	private static String[] devs;

	static 
	{
		devs = new String[] { "demiraven@gmail.com", "aftermathew@gmail.com" };
	}

	// checks authorized ADMIN user for cloud service
	// used within the AppEngine site directly
	@SuppressWarnings("unchecked")
	public static boolean isAuthorizedAdmin() 
	{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (null == user) 
		{
			return false;
		}
		String email = user.getEmail();
		for (int i = 0; i < devs.length; i++) 
		{
			if (devs[i].compareToIgnoreCase(email) == 0) 
			{
				return true;
			}
		}
		// then iterate through additional known admin list.
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Administrator.class.getName();
		List<Administrator> admins = (List<Administrator>) pm.newQuery(query).execute();
		for (int i = 0; i < admins.size(); i++) 
		{
			if (admins.get(i).getEmail().compareToIgnoreCase(email) == 0) 
			{
				return true;
			}
		}
		return false;
	}

	// OAUTH

	public static enum OAUTH_RESULT 
	{
		SUCCESS, 
		UNKNOWN_ERROR, 
		MISSING_PARAMETER, 
		NO_AUTH_HEADER, 
		INVALID_TIMESTAMP, 
		TIMESTAMP_EXPIRED, 
		INVALID_NONCE, 
		BAD_TOKEN, 
		EXPIRED_TOKEN, 
		INVALID_CONSUMER_KEY, 
		INVALID_CONSUMER_SECRET, 
		INVALID_SIGNATURE,
	};

	// verifies oauth timestamp - seconds UTC
	private static OAUTH_RESULT verifyOAuthTimestamp(String timestampStr) 
	{
		OAUTH_RESULT result = OAUTH_RESULT.TIMESTAMP_EXPIRED;
		try 
		{
			long timestamp = Long.parseLong(timestampStr);
			long curTimestampUTC = System.currentTimeMillis() / 1000L;
			// must be within the last 60 seconds - tolerant
			if (timestamp > curTimestampUTC - 60 && timestamp <= curTimestampUTC) 
			{
				result = OAUTH_RESULT.SUCCESS;
			}
		} 
		catch (NumberFormatException nfe) 
		{
			return OAUTH_RESULT.INVALID_TIMESTAMP;
		}
		return result;
	}

	// verifies oauth nonce
	// removes stale (> 6 hour) TokenNonce objects en masse
	// updates existing TokenNonce objects, otherwise creates new
	@SuppressWarnings("unchecked")
	private static OAUTH_RESULT verifyOAuthNonce(String nonce, String token, String timestampStr) 
	{
		OAUTH_RESULT result = OAUTH_RESULT.SUCCESS;
		long timestamp = 0L;
		try 
		{
			// should be already verified
			timestamp = Long.parseLong(timestampStr);
		} 
		catch (NumberFormatException nfe) 
		{
			return OAUTH_RESULT.INVALID_NONCE;
		}
		if (timestamp > 1000000L) // not completely bogus - should be checked prior...
		{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			try 
			{
				// delete all older than 6 hours - keep data slim(ish)
				Query query = pm.newQuery(TokenNonce.class);
				query.setFilter("timestamp < tsVal");
				query.declareParameters("long tsVal");
				query.deletePersistentAll((System.currentTimeMillis() / 1000L) - (long) (60 * 60 * 6)); // all older than now minus 6 hours
				// does a nonce exist for this token?
				String query2 = "select from " + TokenNonce.class.getName() + " where token == " + token;
				List<TokenNonce> tokenNonces = (List<TokenNonce>) pm.newQuery(query2).execute();
				if (tokenNonces.size() > 0) 
				{
					// check existing TokenNonce to see if nonce is unique
					if (tokenNonces.get(0).getNonce().compareTo(nonce) != 0) 
					{
						// unique - update nonce and timestamp
						tokenNonces.get(0).setNonceAndTimestamp(nonce, timestamp);
					} 
					else 
					{
						result = OAUTH_RESULT.INVALID_NONCE;
					}
				} 
				else 
				{
					// add new TokenNonce
					TokenNonce tn = new TokenNonce(token, nonce, timestamp);
					pm.makePersistent(tn);
				}
			} 
			finally 
			{
				pm.close();
			}
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	private static String getOAuthConsumerSecret(String consumerKey) 
	{
		String oauthSecret = null;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try 
		{
			String query = "select from " + Consumer.class.getName() + " where consumerKey == " + consumerKey;
			List<Consumer> consumers = (List<Consumer>) pm.newQuery(query).execute();
			if (consumers.size() >= 0) 
			{
				oauthSecret = consumers.get(0).getSecret();
			}
		} 
		finally 
		{
			pm.close();
		}
		return oauthSecret;
	}

	@SuppressWarnings("unchecked")
	private static OAUTH_RESULT verifyOAuthToken(String token) 
	{
		OAUTH_RESULT result = OAUTH_RESULT.EXPIRED_TOKEN;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try 
		{
			String query = "select from " + Token.class.getName() + " where token == " + token;
			List<Token> tokens = (List<Token>) pm.newQuery(query).execute();
			if (tokens.size() >= 0) 
			{
				Token subjectToken = tokens.get(0);
				if (subjectToken.isExpired()) 
				{
					pm.deletePersistent(subjectToken);
				} 
				else 
				{
					// exists and not expired.
					result = OAUTH_RESULT.SUCCESS;
				}
			}
		} 
		finally 
		{
			pm.close();
		}
		return result;
	}
	
	private static String getTokenSecret(String token)
	{
		//TODO
		
		return "";
	}

	private static String generateOAuthSignature(
			HashMap<String, String> oauthMap, 
			String verb, 
			String URLstr, 
			HashMap<String, String> otherParamsMap,
			String consumerSecret,
			String tokenSecret) 
	{
		if (oauthMap == null || oauthMap.isEmpty() ||
			verb == null || verb.isEmpty() ||
			URLstr == null || URLstr.isEmpty() )
			return "";
		
		//generate signature base string
		//  combine parameters
		HashMap<String, String> allParams = new HashMap<String, String>();
		for (String key : oauthMap.keySet())
		{
			//exclude signature
			if (key.compareTo("oauth_signature") != 0)
				allParams.put(key, oauthMap.get(key));
		}
		for (String key : otherParamsMap.keySet())
		{
			//these should already be properly URL encoded as input, as needed
			allParams.put(key, otherParamsMap.get(key));
		}
		
		//  normalize request parameters
		String[] allParamsKeys = (String[]) allParams.keySet().toArray();
		java.util.Arrays.sort(allParamsKeys);
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < allParamsKeys.length; i++)
		{
			if (i > 0) sb.append('&');
			String key = allParamsKeys[i];
			sb.append(key + '=' + allParams.get(key));
		}
		String normalizedRequestParameterString = sb.toString();
		
		//	need: VERB, URL
		
		//  clean URL to good format
		//  must be absolute URL as input
		String normalizedURLString;
		try 
		{
			java.net.URL url = new java.net.URL(URLstr);
			StringBuilder urlsb = new StringBuilder();
			urlsb.append(url.getProtocol().toLowerCase());
			urlsb.append("://");
			urlsb.append(url.getHost().toLowerCase());
			urlsb.append(url.getPath());
			normalizedURLString = urlsb.toString();
		} 
		catch (MalformedURLException e) 
		{
			return "";
		}
		
		// get clean Verb
		String normalizedVerbString = verb.toUpperCase();
		
		sb = new StringBuilder();
		sb.append(parameterURLEncode(normalizedVerbString));
		sb.append('&');
		sb.append(parameterURLEncode(normalizedURLString));
		sb.append('&');
		sb.append(parameterURLEncode(normalizedRequestParameterString));
		String signatureBaseString = sb.toString();
		
		//calculate signature value
		String signatureKey = parameterURLEncode(consumerSecret) + '&' + parameterURLEncode(tokenSecret);
		try
		{
			SecretKeySpec signingKey = new SecretKeySpec(signatureKey.getBytes(), "HmacSHA1");
			Mac mac = Mac.getInstance("HmacSHA1");
			mac.init(signingKey);
			byte[] rawHmac = mac.doFinal(signatureBaseString.getBytes());
			String result = parameterURLEncode(base64Encode(rawHmac));
			return result;
		}
		catch (Exception e)
		{
			return "";
		}
	}
	
	private static OAUTH_RESULT verifyOAuthSignature(
			HashMap<String, String> oauthMap, 
			String verb, 
			String URLstr, 
			HashMap<String, String> otherParamsMap,
			String consumerSecret,
			String tokenSecret) 
	{
		OAUTH_RESULT result = OAUTH_RESULT.INVALID_SIGNATURE;
		String signatureString = generateOAuthSignature(
				oauthMap, verb, URLstr, otherParamsMap, consumerSecret, tokenSecret);
		if (signatureString.compareTo(oauthMap.get("oauth_signature")) == 0)
			result = OAUTH_RESULT.SUCCESS;
		return result;
	}

	// verifies client request for data
	// used by external services (web, mobile)
	public static OAUTH_RESULT verifyOAuth(HttpServletRequest req) 
	{
		OAUTH_RESULT result = OAUTH_RESULT.UNKNOWN_ERROR;
		String authHeader = req.getHeader("Authorization");
		if (null != authHeader) 
		{
			HashMap<String, String> oauthMap = new HashMap<String, String>();
			// get key-val substrings in Authorization header
			String[] authSections = authHeader.split("[, ]+");
			for (String authSection : authSections) 
			{
				if (authSection.contains("=")) // ignore preceding OAuth val and Realm
				{
					String[] keyVal = authSection.split("=");
					String key = keyVal[0];
					String value = (keyVal[1].length() == 0) ? "" : 
						keyVal[1].substring(1, keyVal[0].lastIndexOf("\"")); // eliminate quotes
					oauthMap.put(key, value);
				}
			}
			if (oauthMap.size() > 0) 
			{
				if (oauthMap.containsKey("oauth_version")
						&& oauthMap.get("oauth_version").compareTo("1.0") == 0
						&& oauthMap.containsKey("oauth_signature_method")
						&& oauthMap.get("oauth_signature_method").compareTo("HMAC_SHA1") == 0
						&& oauthMap.containsKey("oauth_consumer_key")
						&& oauthMap.containsKey("oauth_nonce")
						&& oauthMap.containsKey("oauth_timestamp")
						&& oauthMap.containsKey("oauth_token")
						&& oauthMap.containsKey("oauth_signature")) 
				{
					// verify timestamp within reasonable range
					result = verifyOAuthTimestamp(oauthMap.get("oauth_timestamp"));
					if (result == OAUTH_RESULT.SUCCESS) 
					{
						result = verifyOAuthNonce(oauthMap.get("oauth_nonce"),
								oauthMap.get("oauth_token"), 
								oauthMap.get("oauth_timestamp"));
						if (result == OAUTH_RESULT.SUCCESS) 
						{
							// verify existence of consumer key
							String oauthConsumerSecret = getOAuthConsumerSecret(oauthMap.get("oauth_consumer_key"));
							if (null != oauthConsumerSecret) 
							{
								result = verifyOAuthToken(oauthMap.get("oauth_token"));
								if (result == OAUTH_RESULT.SUCCESS) 
								{
									//TODO
									String oauthTokenSecret = getTokenSecret(oauthMap.get("oauth_token"));
									
									// finally, verify signature
									//TODO: determine additional params
									result = verifyOAuthSignature(oauthMap, "", "", null, oauthConsumerSecret, oauthTokenSecret);
								}
							}
						}
					}
				} 
				else 
				{
					result = OAUTH_RESULT.MISSING_PARAMETER;
				}
			} 
			else 
			{
				result = OAUTH_RESULT.MISSING_PARAMETER;
			}
		} 
		else 
		{
			result = OAUTH_RESULT.NO_AUTH_HEADER;
		}
		return result;
	}

	private static String base64AlphaStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	// home-crafted b64 encoder, since Google does not support sun.misc.*
	public static String base64Encode(byte[] bytes) 
	{
		StringBuilder sb = new StringBuilder();
		int val;
		for (int i = 0; i < bytes.length;) 
		{
			val = (bytes[i] & 0xFC) >> 2;
			sb.append(base64AlphaStr.charAt(val));
			val = (bytes[i++] & 0x03) << 4;
			if (i < bytes.length) 
			{
				val |= (bytes[i] & 0xF0) >> 4;
			}
			sb.append(base64AlphaStr.charAt(val));
			val = 64; // '='
			if (i < bytes.length) 
			{
				val = (bytes[i++] & 0x0F) << 2;
				if (i < bytes.length) 
				{
					val |= (bytes[i] & 0xC0) >> 6;
				}
			} 
			else 
			{
				i++;
			}
			sb.append(base64AlphaStr.charAt(val));
			val = 64; // '='
			if (i < bytes.length) 
			{
				val = (bytes[i] & 0x3F);
			}
			sb.append(base64AlphaStr.charAt(val));
			i++;
		}
		return sb.toString();
	}

	public static byte[] base64Decode(String b64Str) 
	{
		int b64Len = b64Str.length();
		int bytesLen = ((b64Len + 3) / 4) * 3; // ceiling
		if (b64Len > 2 && b64Str.charAt(b64Len - 1) == '=') 
		{
			if (b64Str.charAt(b64Len - 2) == '=') 
			{
				bytesLen -= 1;
				if ((b64Str.charAt(b64Len - 3) & 0x0F) == 0x00) 
				{
					bytesLen -= 1;
				}
			} 
			else if ((b64Str.charAt(b64Len - 2) & 0x03) == 0x00) 
			{
				bytesLen -= 1;
			}
		}
		byte[] bytes = new byte[bytesLen];
		byte val;
		for (int i = 0, curByte = 0; i < b64Len && curByte < bytesLen; ) 
		{
			// 1st byte val
			val = (byte) (base64AlphaStr.indexOf(b64Str.charAt(i++)) << 2);
			val |= (byte) ((base64AlphaStr.indexOf(b64Str.charAt(i)) & 0x30) >> 4);
			bytes[curByte++] = val;
			if (curByte >= bytesLen) break;
			// 2nd byte val
			val = (byte) ((base64AlphaStr.indexOf(b64Str.charAt(i++)) & 0x0F) << 4);
			int b64Val = (base64AlphaStr.indexOf(b64Str.charAt(i)));
			val |= (byte) ((b64Val < 64) ? ((b64Val & 0x3C) >> 2) : 0x00);
			bytes[curByte++] = val;
			if (curByte >= bytesLen) break;
			// 3rd byte val
			if (b64Val < 64) 
			{
				val = (byte) ((b64Val & 0x03) << 6);
				b64Val = (base64AlphaStr.indexOf(b64Str.charAt(++i)));
				if (b64Val != 64) 
				{
					val |= (byte) b64Val;
				}
				bytes[curByte++] = val;
			} 
			else 
			{
				i++;
			}
		}
		// HACK - need to fix one-off (error adds trailing 0 byte)
		if (bytes[bytes.length - 1] == 0) 
		{
			byte[] newBytes = new byte[bytes.length - 1];
			for (int i = 0; i < bytes.length - 1; i++) 
			{
				newBytes[i] = bytes[i];
			}
			return newBytes;
		} 
		else
		{
			return bytes;
		}
	}
	

	//acceptable chars in parameter encoding are A-Z, a-z, 0-9, - _ . and ~
	//note: hex chars MUST be in uppercase.
	//input must be UTF-8 prior to encoding
	public static String parameterURLEncode(String initStr)
	{
		String unreserved = "_-.~";
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < initStr.length(); i++)
		{
			char c = initStr.charAt(i);
			if (Character.isLetterOrDigit(c) || unreserved.indexOf(c) >= 0)
			{
				sb.append(c);
			}
			else
			{
				byte b = (byte)c;
				sb.append('%');
				char c2 = (char)(((b & 0xF0) >> 4) + '0');
				if (c2 > '9') c2 = (char)(c2 - '9' - 1 + 'A');
				sb.append(c2);
				c2 = (char)((b & 0x0F) + '0');
				if (c2 > '9') c2 = (char)(c2 - '9' - 1 + 'A');
				sb.append(c2);
			}
		}
		return sb.toString();
	}
	
	public static String parameterURLDecode(String initStr)
	{
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < initStr.length(); i++)
		{
			char c = initStr.charAt(i);
			if (c == '%')
			{
				c = initStr.charAt(++i);
				byte b = (c <= '9') ? (byte)(c - '0') : (byte)(c - 'A' + 10);
				b <<= 4;
				c = initStr.charAt(++i);
				b |= (c <= '9') ? (byte)(c - '0') : (byte)(c - 'A' + 10);
				c = (char)b;
			}
			sb.append(c);
		}
		return sb.toString();
	}
	
	
	
}
