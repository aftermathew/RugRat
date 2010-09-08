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
public class Ticket {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key idKey;
	
	@Persistent
	private String ticket;
	
	@Persistent
	private String token;
	
	@Persistent
	private long expiration;
	
	public Ticket(String token)
	{
		this.token = token;
		this.ticket = generateTicket();
		refresh();
	}

	public String getTicket(){return ticket;}
	
	public String getToken(){return token;}

	public long getExpiration(){return expiration;}
	
	public boolean isExpired()
	{
		return (this.expiration < (System.currentTimeMillis() / 1000L)) ? true : false;
	}
	
	private String generateTicket()
	{
		int byteArrLen = 20;
		Random rand = new Random();
		byte[] randBytes = new byte[byteArrLen]; 
		rand.nextBytes(randBytes);
		String ticket = utility.base64Encode(randBytes);
		return ticket;
	}
	
	public void refresh()
	{
		//3 hour expiration
		this.expiration = (System.currentTimeMillis() / 1000L) + (long)(3 * 60 * 60);
	}
	
	
	//This is used to set the ticket in the persistent datastore
	@SuppressWarnings("unchecked")
	public void persist()
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + com.bitsyrup.rugrat.common.Ticket.class.getName() + 
			" where ticket == '" + this.ticket + "'";
		List<Ticket> tickets = (List<Ticket>)pm.newQuery(query).execute();
		if (tickets == null || tickets.size() == 0)
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

