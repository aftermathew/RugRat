package com.bitsyrup.rugrat.common;

import com.google.appengine.api.datastore.Key;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class User {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String name;
	
	@Persistent
	private String email;
	
	@Persistent
	private String passwordHash;
	
	public User(String name, String email, String passwordHash)
	{
		this.name = name;
		this.email = email;
		this.passwordHash = passwordHash;
	}

	public String getName(){return name;}
	
	public String getEmail(){return email;}

	public Key getKey(){return key;}
	
	public String getPasswordHash(){return passwordHash;}
}
