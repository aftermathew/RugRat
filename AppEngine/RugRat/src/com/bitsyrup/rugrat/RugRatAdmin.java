package com.bitsyrup.rugrat;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import javax.jdo.PersistenceManager;

import com.bitsyrup.rugrat.common.auth;
import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Administrator;
import com.google.appengine.api.users.*;

@SuppressWarnings("serial")
public class RugRatAdmin extends HttpServlet {

	//handles jsp forwarding
	private void handleJSPForward(String url, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		RequestDispatcher rd = req.getRequestDispatcher(url);
    	try {
			rd.forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}
	
	//entry GET
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        String thisURL = req.getRequestURI();
        if (req.getUserPrincipal() == null)
        {
        	String loginURL = userService.createLoginURL(thisURL);
        	req.setAttribute("liu", loginURL);
        	handleJSPForward("/login.jsp", req, resp);
        }
        else
        {   
        	if (auth.isAuthorized())
        	{	
	        	String uploadURL = "/admin";
	        	req.setAttribute("ulu", uploadURL);
	        	req.setAttribute("lou", userService.createLogoutURL(thisURL));
	        	handleJSPForward("/users.jsp", req, resp);
        	}
        	else
        	{
        		String logoutURL = userService.createLogoutURL(thisURL);
        		req.setAttribute("lou", logoutURL);
	        	handleJSPForward("/unauthorized.jsp", req, resp);
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
        	String email = req.getParameter("email");
        	String username = req.getParameter("name");
        	if (email.contains("gmail.com"))
        	{
        		Administrator administrator = new Administrator(username, email);
        		PersistenceManager pm = PMF.get().getPersistenceManager();
        		try
        		{
        			pm.makePersistent(administrator);
        		}
        		finally
        		{
        			pm.close();
        		}
        		req.setAttribute("msg", "Added user " + email);
        	}
        	else
        	{
	        	req.setAttribute("msg", "The user email must be in the gmail.com domain");
        	}
        	String uploadURL = "/admin";
        	req.setAttribute("ulu", uploadURL);
            UserService userService = UserServiceFactory.getUserService();
        	req.setAttribute("lou", userService.createLogoutURL(req.getRequestURI()));
        	handleJSPForward("/users.jsp", req, resp);
        }
	}
}
