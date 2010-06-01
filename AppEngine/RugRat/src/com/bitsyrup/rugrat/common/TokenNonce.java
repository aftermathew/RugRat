package com.bitsyrup.rugrat.common;

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
public class TokenNonce {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key idKey;
	
	@Persistent
	private String token;
	
	@Persistent
	private String nonce;
	
	@Persistent
	private long timestamp;
	
	public TokenNonce(String token, String nonce, long timestamp)
	{
		this.token = token;
		this.nonce = nonce;
		this.timestamp = timestamp;
	}

	public String getToken(){return token;}
	
	public String getNonce(){return nonce;}

	public long getTimestamp(){return timestamp;}
	
	public void setNonceAndTimestamp(String nonce, long timestamp)
	{
		this.nonce = nonce;
		this.timestamp = timestamp;
	}

	public void setIdKey(Key idKey) {
		this.idKey = idKey;
	}

	public Key getIdKey() {
		return idKey;
	}
}
