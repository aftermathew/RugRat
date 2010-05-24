package com.bitsyrup.rugrat.xmlserializable;

import java.util.regex.Matcher;
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
		Pattern pat1 = Pattern.compile("<name>([^<]+)</name>");
		Matcher match1 = pat1.matcher(xml);
		String name = match1.find() ? match1.group(1) : "";
		this.setName(name);
		Pattern pat2 = Pattern.compile("<email>([^<]+)</email>");
		Matcher match2 = pat2.matcher(xml);
		String email = match2.find() ? match2.group(1) : "";
		this.setEmail(email);
		Pattern pat3 = Pattern.compile("<password>([^<]+)</password>");
		Matcher match3 = pat3.matcher(xml);
		String pw = match3.find() ? match3.group(1) : "";
		if (pw.isEmpty())
			this.setPasswordHash("");
		else
			this.setPasswordHash(new String(utility.base64Encode(utility.hashSHA1(pw + utility.HASHSALT))));
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
