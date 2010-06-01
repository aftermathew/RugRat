package com.bitsyrup.rugrat.common;

import java.util.List;

import com.google.appengine.api.datastore.Key;

import javax.jdo.PersistenceManager;
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
	
	//This is used to set the token in the persistent datastore
	@SuppressWarnings("unchecked")
	public void persist() throws Exception
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		//use email as unique member
		String query = "select from " + User.class.getName() + " where email == \"" + this.email + "\"";
		List<User> users = (List<User>)pm.newQuery(query).execute();
		if (users == null || users.size() == 0)
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
		else
		{
			throw new Exception("member exists already");
		}
	}
}
