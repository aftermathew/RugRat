package com.bitsyrup.rugrat.response;

import com.bitsyrup.rugrat.common.utility;

public class ErrorResponse implements I_XMLSerializable {
	
	private String code;
	private String message;
	
	public ErrorResponse(){}
	public ErrorResponse(String xml){this.fromXML(xml);}
	
	@Override
	public void fromXML(String xml) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public String toXML() {
		StringBuilder sb = new StringBuilder();
		sb.append("<errorResponse>\n");
		sb.append("  <code>" + utility.xmlEncode(this.getCode()) + "</code>\n");
		sb.append("  <message>" + utility.xmlEncode(this.getMessage()) + "</message>\n");
		sb.append("</errorMessage>");
		return sb.toString();
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public String getCode() {
		return code;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getMessage() {
		return message;
	}
}
