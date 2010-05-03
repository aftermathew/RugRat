package com.bitsyrup.rugrat;

import java.io.IOException;

//import javax.servlet.RequestDispatcher;
//import javax.servlet.ServletException;
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
	//@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException 
	{
		resp.getWriter().write("OK!\n");
	}
}

