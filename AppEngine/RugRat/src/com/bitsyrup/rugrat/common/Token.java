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
		refresh();
	}

	public String getToken(){return token;}

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
		//TODO - writing b64 encoder
		return "";
	}
	
	public void refresh()
	{
		this.expiration = (System.currentTimeMillis() / 1000L) + (long)(60 * 60);
	}
}

