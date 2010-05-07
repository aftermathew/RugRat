package com.bitsyrup.rugrat.response;
import com.bitsyrup.rugrat.common.utility;

public class TokenResponse implements I_XMLSerializable
{
	private String name;
	private String token;
	private String tokenSecret;
	
	public TokenResponse(){}
	public TokenResponse(String xml){this.fromXML(xml);}
	
	@Override
	public void fromXML(String xml) {
		// TODO Auto-generated method stub
	}

	@Override
	public String toXML() {
		StringBuilder sb = new StringBuilder();
		sb.append("<tokenResponse>\n");
		sb.append("  <name>" + utility.xmlEncode(this.getName()) + "</name>\n");
		sb.append("  <token>" + utility.xmlEncode(this.getToken()) + "</token>\n");
		sb.append("  <tokenSecret>" + utility.xmlEncode(this.getTokenSecret()) + "</tokenSecret>\n");
		sb.append("</tokenResponse>");
		return sb.toString();
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getToken() {
		return token;
	}

	public void setTokenSecret(String tokenSecret) {
		this.tokenSecret = tokenSecret;
	}

	public String getTokenSecret() {
		return tokenSecret;
	}

}
