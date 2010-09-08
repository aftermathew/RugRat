package com.bitsyrup.rugrat.xmlserializable;
import com.bitsyrup.rugrat.common.utility;

public class TicketResponse implements I_XMLSerializable
{
	private String ticket;
	
	public TicketResponse(){}
	public TicketResponse(String ticket)
	{
		this.ticket = ticket;
	}
	
	@Override
	public void fromXML(String xml) {
		// TODO Auto-generated method stub
	}

	@Override
	public String toXML() {
		StringBuilder sb = new StringBuilder();
		sb.append("<ticketResponse>\n");
		sb.append("  <ticket>" + utility.xmlEncode(this.getTicket()) + "</name>\n");
		sb.append("</ticketResponse>");
		return sb.toString();
	}

	public void setTicket(String ticket) {
		this.ticket = ticket;
	}

	public String getTicket() {
		return ticket;
	}

}
