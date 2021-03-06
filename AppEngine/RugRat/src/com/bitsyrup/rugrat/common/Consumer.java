package com.bitsyrup.rugrat.common;

import java.util.Random;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

//this is the mapping of a nonce to a token - can exist for 6 hours,
//	in case the application refreshes a token without query
//NOTE: this only applies to the last nonce.  A stronger algorithm would recall
//  multiple nonces, but that would require additional memory...
@PersistenceCapable
public class Consumer {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key idKey;
	 
	@Persistent
	private String consumerKey;
	
	@Persistent
	private String consumerSecret;
	
	@Persistent
	private String consumerName;
	
	public Consumer(String name)
	{
		this.consumerName = name;
		this.consumerKey = generateConsumerKey();
		this.consumerSecret = generateConsumerSecret();
	}
	
	public String getKey(){return consumerKey;}
	
	public String getSecret(){return consumerSecret;}
	
	public String getName(){return consumerName;}
	
	private String generateConsumerKey()
	{
		int byteArrLen = 20;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String key = utility.base64Encode(randBytes);
		return key;
	}
	
	private String generateConsumerSecret()
	{
		int byteArrLen = 32;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String secret = utility.base64Encode(randBytes);
		return secret;
	}

	public void setIdKey(Key idKey) {
		this.idKey = idKey;
	}

	public Key getIdKey() {
		return idKey;
	}

}
