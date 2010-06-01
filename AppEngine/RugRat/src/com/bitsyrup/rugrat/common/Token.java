package com.bitsyrup.rugrat.common;

import java.util.List;
import java.util.Random;
import com.bitsyrup.rugrat.common.utility;
import com.google.appengine.api.datastore.Key;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

//valid token - this has an exipration unless updated...
@PersistenceCapable
public class Token {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key idKey;
	
	@Persistent
	private String token;
	
	@Persistent
	private String tokenSecret;
	
	@Persistent
	private long expiration;
	
	@Persistent
	private String userID;
	
	@Persistent
	private String consumerKey;
	
	public Token(String userID, String consumerKey)
	{
		this.userID = userID;
		this.consumerKey = consumerKey;
		this.token = generateToken();
		this.tokenSecret = generateTokenSecret();
		refresh();
	}

	public String getToken(){return token;}
	
	public String getTokenSecret(){return tokenSecret;}

	public long getExpiration(){return expiration;}
	
	public String getUserID(){return userID;}
	
	public String getConsumerKey(){return consumerKey;}
	
	public boolean isExpired()
	{
		return (this.expiration < (System.currentTimeMillis() / 1000L)) ? true : false;
	}
	
	private String generateToken()
	{
		int byteArrLen = 20;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String token = utility.base64Encode(randBytes);
		return token;
	}
	
	private String generateTokenSecret()
	{
		int byteArrLen = 32;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String tokenSecret = utility.base64Encode(randBytes);
		return tokenSecret;
	}
	
	public void refresh()
	{
		this.expiration = (System.currentTimeMillis() / 1000L) + (long)(60 * 60);
	}
	
	
	//This is used to set the token in the persistent datastore
	@SuppressWarnings("unchecked")
	public void persist()
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + com.bitsyrup.rugrat.common.Token.class.getName() + 
			" where token == '" + this.token + "'";
		List<Token> tokens = (List<Token>)pm.newQuery(query).execute();
		if (tokens == null || tokens.size() == 0)
		{
			try
			{
				pm.makePersistent(this);
			}
			catch (Exception e)
			{
				//TODO: log error 
			}
		}
	}

	public void setIdKey(Key idKey) {
		this.idKey = idKey;
	}

	public Key getIdKey() {
		return idKey;
	}
}

