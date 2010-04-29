package com.bitsyrup.rugrat.common;

import java.util.Random;

import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

//valid token - this has an exipration unless updated...
@PersistenceCapable
public class Token {
	@PrimaryKey
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
		String token = auth.base64Encode(randBytes);
		return token;
	}
	
	private String generateTokenSecret()
	{
		int byteArrLen = 32;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String tokenSecret = auth.base64Encode(randBytes);
		return tokenSecret;
	}
	
	public void refresh()
	{
		this.expiration = (System.currentTimeMillis() / 1000L) + (long)(60 * 60);
	}
}

