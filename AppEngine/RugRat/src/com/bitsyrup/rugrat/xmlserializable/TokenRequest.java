package com.bitsyrup.rugrat.xmlserializable;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


import com.bitsyrup.rugrat.common.utility;

public class TokenRequest implements I_XMLSerializable {
    
	private String digest;
	
	public TokenRequest(){}
	public TokenRequest(String xml){this.fromXML(xml);}
	
	@Override
	public void fromXML(String xml) {
		Pattern pat = Pattern.compile("<digest>([^<]*)</digest>");
    	Matcher match = pat.matcher(xml);
		String contentBase64 = match.find() ? match.group(1) : "";
    	this.digest = new String(utility.base64Decode(contentBase64));
	}
	
	@Override
	public String toXML() {
		// TODO Auto-generated method stub
		return null;
	}
	
	public void setDigest(String digest) {
		this.digest = digest;
	}
	
	public String getDigest() {
		return digest;
	}
	
	
}
