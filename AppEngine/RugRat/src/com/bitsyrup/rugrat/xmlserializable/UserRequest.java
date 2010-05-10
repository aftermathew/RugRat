package com.bitsyrup.rugrat.xmlserializable;

import java.util.regex.Pattern;

import com.bitsyrup.rugrat.common.utility;

public class UserRequest implements I_XMLSerializable {

	private String name;
	private String email;
	private String passwordHash;
	
	public UserRequest(){}
	public UserRequest(String xml){this.fromXML(xml);}
	
	@Override
	public void fromXML(String xml) {
		Pattern pat = Pattern.compile("<name>([^<]*)</name>");
		Pattern pat2 = Pattern.compile("<email>([^<]*)</email>");
		Pattern pat3 = Pattern.compile("<password>([^<]*)</password>");
		this.setName(pat.matcher(xml).group(0));
		this.setEmail(pat2.matcher(xml).group(0));
		this.setPasswordHash(new String(utility.hashSHA1(pat3.matcher(xml).group(0) + utility.HASHSALT)));
	}
	
	@Override
	public String toXML() {
		// TODO Auto-generated method stub
		return null;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}
	
	public String getPasswordHash() {
		return passwordHash;
	}
}
