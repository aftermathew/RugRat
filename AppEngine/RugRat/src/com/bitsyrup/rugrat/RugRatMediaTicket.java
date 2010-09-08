package com.bitsyrup.rugrat;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Ticket;
import com.bitsyrup.rugrat.common.oauth;
import com.bitsyrup.rugrat.xmlserializable.ErrorResponse;
import com.bitsyrup.rugrat.xmlserializable.TicketResponse;

//NOTE: this is all under HTTPS, see web.xml

/*********************
 * XML description
 * 
 * for auth request (POST):
 *   NO BODY REQUIRED
 * 
 * for auth response (POST):
 * <ticketResponse>
 *     <ticket>[ticket value]</ticket>
 * <ticketResponse>
 * 
 * for error response (POST):
 * <error>
 *     <message>[error message]</message>
 *     <code>[error code (optional)]</errorCode>
 * </error>
 * 
 */

@SuppressWarnings("serial")
public class RugRatMediaTicket extends HttpServlet {

	//logger
    private static final Logger log = Logger.getLogger(RugRatAssets.class.getName());
	
    //token request
	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException 
	{
		oauth.OAUTH_RESULT result = oauth.verifyOAuth(req, true);
		
		if (result == oauth.OAUTH_RESULT.SUCCESS)
		{
			//success.  create new ticket for user
			String token = oauth.getOAuthValue(req, "oauth_token");
			PersistenceManager pm = PMF.get().getPersistenceManager();
			String query = "select from " + com.bitsyrup.rugrat.common.Ticket.class.getName() + 
				" where token == '" + token + "'";
			List<Ticket> tickets = (List<Ticket>) pm.newQuery(query).execute();
			Ticket ticket = null;
			if (tickets.size() > 0)
			{
				//return existing ticket
				ticket = tickets.get(0);
				//TODO: handle expiration?
			}
			else
			{
				//create new token
				ticket = new Ticket(token);
				ticket.persist();
			}
			TicketResponse tresp = new TicketResponse(ticket.getTicket());
			String xml = tresp.toXML();
			resp.setStatus(200);
			resp.getWriter().write(xml);
		}
		else
		{
			log.log(Level.WARNING, "Received OAuth ticket request failure: " + result.toString());
			PrintWriter writer = resp.getWriter();
			ErrorResponse error = new ErrorResponse(
					String.valueOf(result.ordinal()), 
					"OAuth request failure: " + result.toString());
			resp.setStatus(401);
			writer.write(error.toXML());
		}
	}
}

