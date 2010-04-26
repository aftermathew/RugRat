package com.bitsyrup.rugrat.common;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Administrator;

import java.util.HashMap;
import java.util.List;

public class auth {

	private static String[] devs;
	
	static 
	{
		devs = new String[]{"demiraven@gmail.com", "aftermathew@gmail.com"};
	}
	
	//checks authorized ADMIN user for cloud service
	//	used within the AppEngine site directly
	@SuppressWarnings("unchecked")
	public static boolean isAuthorized()
	{
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (null == user)
        	return false;
        String email = user.getEmail();
		for (int i = 0; i < devs.length; i++)
		{
			if (devs[i].compareToIgnoreCase(email) == 0)
				return true;
		}
		//then iterate through additional known admin list.
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Administrator.class.getName();
		List<Administrator> admins = (List<Administrator>)pm.newQuery(query).execute();
		for (int i = 0; i < admins.size(); i++)
		{
			if (admins.get(i).getEmail().compareToIgnoreCase(email) == 0)
				return true;
		}
		return false;
	}
	
	//verifies oauth timestamp - seconds UTC
	private static boolean verifyOAuthTimestamp(String timestampStr)
	{
		boolean verified = false;
		try
		{
			long timestamp = Long.parseLong(timestampStr);
			long curTimestampUTC = System.currentTimeMillis() / 1000L;
			//must be within the last 60 seconds - tolerant
			if (timestamp > curTimestampUTC - 60 && timestamp <= curTimestampUTC)
				verified = true;
		}
		catch (NumberFormatException nfe)
		{
			return false;
		}
		return verified;
	}
	
	//verifies oauth nonce
	//	removes stale (> 6 hour) TokenNonce objects en masse
	//	updates existing TokenNonce objects, otherwise creates new
	@SuppressWarnings("unchecked")
	private static boolean verifyOAuthNonce(String nonce, String token, String timestampStr)
	{
		boolean verified = false;
		long timestamp = 0L;
		try
		{
			//should be already verified
			timestamp = Long.parseLong(timestampStr);
		}
		catch (NumberFormatException nfe)
		{
			return false;
		}
		if (timestamp > 1000000L) //not completely bogus - should be checked prior...
		{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			try
			{
				//delete all older than 6 hours - keep data slim(ish)
				Query query = pm.newQuery(TokenNonce.class);
				query.setFilter("timestamp < tsVal");
				query.declareParameters("long tsVal");
				query.deletePersistentAll((System.currentTimeMillis() / 1000L) - (long)(60 * 60 * 6)); //all older than now minus 6 hours 
				//does a nonce exist for this token?
				String query2 = "select from " + TokenNonce.class.getName() + " where token == " + token;
				List<TokenNonce> tokenNonces = (List<TokenNonce>)pm.newQuery(query2).execute();
				if (tokenNonces.size() > 0)
				{
					//check existing TokenNonce to see if nonce is unique
					if (tokenNonces.get(0).getNonce().compareTo(nonce) != 0)
					{
						//unique - update nonce and timestamp
						tokenNonces.get(0).setNonceAndTimestamp(nonce, timestamp);
						verified = true;
					}
				}
				else
				{
					//add new TokenNonce
					TokenNonce tn = new TokenNonce(token, nonce, timestamp);
					pm.makePersistent(tn);
					verified = true;
				}
			}
			finally
			{
				pm.close();
			}
		}
		return verified;
	}
	
	private static String getOAuthConsumerSecret(String oauthKey)
	{
		String oauthSecret = null;
		
		return oauthSecret;
	}
	
	//verifies client request for data
	//	used by external services (web, mobile)
	public static boolean verifyOAuth(HttpServletRequest req)
	{
		boolean verified = false;
		String authHeader = req.getHeader("Authorization");
		if (null != authHeader)
		{
			HashMap<String,String> oauthMap = new HashMap<String,String>();
			//get key-val substrings in Authorization header
			String[] authSections = authHeader.split("[, ]+");
			for (String authSection : authSections)
			{
				if (authSection.contains("=")) //ignore preceding OAuth val
				{
					String[] keyVal = authSection.split("=");
					String key = keyVal[0];
					String value = keyVal[0].substring(1, keyVal[0].lastIndexOf("\"")); //eliminate quotes
					oauthMap.put(key, value);
				}
			}
			if (oauthMap.size() > 0)
			{
				if (oauthMap.containsKey("oauth_version") && oauthMap.get("oauth_version").compareTo("1.0") == 0 &&
					oauthMap.containsKey("oauth_signature_method") && oauthMap.get("oauth_signature_method").compareTo("HMAC_SHA1") == 0 &&
					oauthMap.containsKey("oauth_consumer_key") &&
					oauthMap.containsKey("oauth_nonce") &&
					oauthMap.containsKey("oauth_timestamp") &&
					oauthMap.containsKey("oauth_token") &&
					oauthMap.containsKey("oauth_signature"))
				{
					//verify timestamp within reasonable range
					if (verifyOAuthTimestamp(oauthMap.get("oauth_timestamp")))
					{
						//verify nonce as reasonably unique
						if (verifyOAuthNonce(oauthMap.get("oauth_nonce"), oauthMap.get("oauth_token"), oauthMap.get("oauth_timestamp")))
						{
							//verify existence of consumer key
							String oauthConsumerSecret = getOAuthConsumerSecret(oauthMap.get("oauth_consumer_key"));
							if (null != oauthConsumerSecret)
							{
								//verify freshness of token
								//TODO
								//finally, verify signature
								//TODO
							}
						}
					}
				}
					
			}
		}
		return verified;
	}
	
	private static String base64AlphaStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	//home-crafted b64 encoder, since Google does not support sun.misc.BASE64Encoder for some reason.
	public static String base64Encode(byte[] bytes, int length)
	{
		StringBuilder sb = new StringBuilder();
		int bits = length * 8;
		int b64chars = (bits + 5) / 6; //+5 to get ceiling
		for (int symbol = 0; symbol < b64chars; symbol++)
		{
			int byteNumber = (symbol * 6) / 8;
			int curBit = (symbol * 6) - (byteNumber * 8);
			int symIndex = 0;
			for (int i = 0; i < 6; i++)
			{
				int val = bytes[byteNumber] & (0x1 << (7 - curBit));
				symIndex <<= 1;
				symIndex |= (byteNumber < length && val > 0) ? 0x1 : 0x0;
				curBit++;
				if (curBit > 7) 
				{
					curBit = 0;
					byteNumber++;
				}
			}
			sb.append(base64AlphaStr.charAt(symIndex));
		}
		int sbLen = sb.length();
		int charRem = 4 - (sbLen - ((sbLen / 4) * 4));
		if (charRem == 4) charRem = 0;
		while (charRem > 0)
		{
			sb.append('=');
			charRem--;
		}
		return sb.toString();
	}
}
