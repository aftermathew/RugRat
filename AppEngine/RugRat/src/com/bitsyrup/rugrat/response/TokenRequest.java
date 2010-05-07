package com.bitsyrup.rugrat.response;

public class TokenRequest implements I_XMLSerializable {

	private String digest;
	
	public TokenRequest(){}
	public TokenRequest(String xml){this.fromXML(xml);}
	
	@Override
	public void fromXML(String xml) {
		// TODO parse xml to get digest value
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
