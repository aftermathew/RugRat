package com.bitsyrup.rugrat.common;

import com.google.appengine.api.datastore.Key;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class Administrator {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String name;
	
	@Persistent
	private String email;
	
	public Administrator(String name, String email)
	{
		this.name = name;
		this.email = email;
	}

	public String getName(){return name;}
	
	public String getEmail(){return email;}

	public Key getKey(){return key;}
}
