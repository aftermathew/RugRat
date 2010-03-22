package com.bitsyrup.rugrat;

import java.io.IOException;
import java.io.PrintWriter;


import javax.servlet.http.*;

import com.bitsyrup.rugrat.common.auth;
import com.google.appengine.api.users.*;

@SuppressWarnings("serial")
public class RugRatAdmin extends HttpServlet {

	//entry GET
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        String thisURL = req.getRequestURI();
        if (req.getUserPrincipal() == null)
        {
        	resp.getWriter().println("<p>Please <a href=\"" + 
        			userService.createLoginURL(thisURL) +
                    "\">sign in</a>.</p>");
        }
        else
        {   
        	PrintWriter respWriter = resp.getWriter();
        	if (auth.isAuthorized())
        	{	
	        	//call self as POST
        		//TODO: pull this into a jsp
	        	String uploadURL = "/admin";
	        	respWriter.print("<html>\n\t<head>\n\t\t<title>RugRat Admin</title>\n\t</head>");
	        	respWriter.print("\n\t<body>");
	        	respWriter.print("\n\t\t<h3>Add new admin:</h3>");
	        	respWriter.print("\n\t\t<form action=\"");
	        	respWriter.print(uploadURL);
	        	respWriter.print("\" method=\"post\" >");
	        	respWriter.print("\n\t\t\t<input type=\"text\" name=\"email\" />");
	        	respWriter.print("\n\t\t\t<input type=\"submit\" value=\"Submit\" />");
	        	respWriter.print("\n\t\t</form>");
	        	respWriter.print("\n\t\t<p>Or you can <a href=\"" + 
	        			userService.createLogoutURL(thisURL) +
	                    "\">sign out</a>.</p>");
	        	respWriter.print("\n\t</body>");
	        	respWriter.print("\n</html>");
        	}
        	else
        	{
        		respWriter.print("<html><head><title>Not Authorized</title></head>");
        		respWriter.println("<p>Sorry, you are not authorized.</p>");
        		respWriter.print("\n\t\t<p>You can <a href=\"" + 
	        			userService.createLogoutURL(thisURL) +
	                    "\">sign out, however</a>.</p>");
        		respWriter.print("</html");
        	}
        }
	}
	
	//binary upload post
	//@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		//UserService userService = UserServiceFactory.getUserService();
        if (req.getUserPrincipal() == null)
        {
        	//on auth fail, send GET to this page
        	resp.sendRedirect("admin");
        }
        else
        {
        	//handle post logic here
        	resp.getWriter().println("woop woop.");
        }
	}
}
