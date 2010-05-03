package com.bitsyrup.rugrat;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.User;
import com.bitsyrup.rugrat.common.utility;

import java.io.IOException;
import java.util.List;

//import javax.servlet.RequestDispatcher;
//import javax.servlet.ServletException;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;

//NOTE: this is all under HTTPS, see web.xml

@SuppressWarnings("serial")
public class RugRatToken extends HttpServlet {

	//handles jsp forwarding
	/*
	private void handleJSPForward(String url, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		RequestDispatcher rd = req.getRequestDispatcher(url);
    	try {
			rd.forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}
	*/
	
	//token request
	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException 
	{
		String[] headerParts = req.getHeader("Authorization").trim().split(" ");
		if (headerParts[0].equalsIgnoreCase("basic"))
		{
			//get the name and password hash from the data
			String digestStr = new String(utility.base64Decode(headerParts[1]));
			String[] digestParts = digestStr.split(":");
			String name = digestParts[0];
			//the incoming password is unsalted and raw - salt and hash
			String passwordHashStr = new String(utility.hashSHA1(digestParts[1] + utility.HASHSALT));
			
			//confirm valid user
			PersistenceManager pm = PMF.get().getPersistenceManager();
			String query = "select passwordHash from " + User.class.getName() + " where name == " + name;
			List<String> pwhashes = (List<String>)pm.newQuery(query).execute();
			
			if (pwhashes.size() <= 0 || false == pwhashes.get(1).equals(passwordHashStr)) 
				resp.sendError(401, "Not Authorized"); //TODO: send xml error message
			
			//else good - send token
			//TODO - determine xml format for sending token + token secret
			
			//TEST: 
			resp.getWriter().write("Token for you!");
		}
		else
		{
			//TODO: send xml error message
			resp.sendError(401, "Please use basic authentication");
		}
	}
}

