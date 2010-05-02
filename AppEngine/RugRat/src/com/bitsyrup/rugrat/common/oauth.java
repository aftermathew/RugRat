package com.bitsyrup.rugrat.common;

import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;

import com.bitsyrup.rugrat.common.utility;

public class oauth {
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
	
	@SuppressWarnings("unchecked")
	private static String getTokenSecret(String token)
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Token.class.getName() + " where token == " + token;
		List<Token> tokens = (List<Token>) pm.newQuery(query).execute();
		if (tokens.size() > 0)
		{
			return tokens.get(0).getTokenSecret();
		}
		else
		{
			return "";
		}
	}

	private static String generateOAuthSignatureNormalizedParameterString(
			HashMap<String, String> allParams)
	{
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
		return normalizedRequestParameterString;
	}
	
	private static String generateOAuthSignatureNormalizedURLString(String URLstr)
	{
		String normalizedURLString = "";
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
			;
		}
		return normalizedURLString;
	}
	
	private static String generateOAuthSignatureBaseString(
			String normalizedVerbString,
			String normalizedURLString,
			String normalizedRequestParameterString)
	{
		StringBuilder sb = new StringBuilder();
		sb.append(utility.parameterURLEncode(normalizedVerbString));
		sb.append('&');
		sb.append(utility.parameterURLEncode(normalizedURLString));
		sb.append('&');
		sb.append(utility.parameterURLEncode(normalizedRequestParameterString));
		return sb.toString();
	}
	
	private static String generateOAuthSignatureKey(
			String consumerSecret, String tokenSecret)
	{
		String encodedConsumerSecret = utility.parameterURLEncode(consumerSecret);
		String encodedTokenSecret = utility.parameterURLEncode(tokenSecret);
		return encodedConsumerSecret + "&" + encodedTokenSecret;
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
		
		// gather relevant parameters
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
		
		// get normalized parameter string 
		String normalizedRequestParameterString = 
			generateOAuthSignatureNormalizedParameterString(allParams);
		
		// get clean URL to good format - must be absolute URL as input
		String normalizedURLString = 
			generateOAuthSignatureNormalizedURLString(URLstr);
		
		// get clean verb
		String normalizedVerbString = verb.toUpperCase();
		
		// get signature base string 
		String signatureBaseString = 
			generateOAuthSignatureBaseString(
					normalizedVerbString, normalizedURLString, normalizedRequestParameterString);
		
		// get signature key
		String signatureKey = 
			generateOAuthSignatureKey(consumerSecret, tokenSecret);
		
		//calculate signature value
		byte[] hash = utility.hashHmacSHA1(signatureBaseString, signatureKey);
		
		return (null == hash) ? "" : utility.parameterURLEncode(utility.base64Encode(hash));
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

}
