package com.bitsyrup.rugrat.common.assets;

import java.util.Date;
import java.text.DateFormat;

public class Asset {

	public Asset(String name, String key, Date created, long size, String contentType){
		this.name = name;
		this.key = key;
		this.created = created;
		this.size = size;
		this.contentType = contentType;
	}
	
	public String getName(){return name;}
	public String getKey(){return key;}
	public Date getCreated(){return created;}
	public String getCreatedShortString(){return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT).format(created);}
	public long getSize(){return size;}
	public String getContentType(){return contentType;}
	
	private String name;
	private String key;
	private Date created;
	private long size;
	private String contentType;
}
