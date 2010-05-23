package com.bitsyrup.rugrat;

import java.io.IOException;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitsyrup.rugrat.common.Consumer;
import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.auth;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class RugRatConsumer extends HttpServlet {

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
        	handleJSPForward("/requestlogin.jsp", req, resp);
        }
        else
        {   
        	if (auth.isAuthorizedAdmin())
        	{	
        		String verb = req.getParameter("verb");
        		if (null != verb && verb.compareTo("delete") == 0)
        		{
        			String key = req.getParameter("key");
        			if (null != key)
        			{
        				PersistenceManager pm = PMF.get().getPersistenceManager();
        				try
        				{
        					Query query = pm.newQuery(Consumer.class);
        					query.setFilter("consumerKey == inputKey");
        					query.declareParameters("String inputKey");
        					query.deletePersistentAll(key);
        				}
        				finally
        				{
        					pm.close();
        				}
        			}
        		}
            	String uploadURL = "/consumer";
            	req.setAttribute("ulu", uploadURL);
            	req.setAttribute("lou", userService.createLogoutURL(thisURL));
            	handleJSPForward("/consumers.jsp", req, resp);
 
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
        	resp.sendRedirect("consumer");
        }
        else
        {
        	//handle post logic here
        	String serviceName = req.getParameter("name");
        	Consumer consumer = new Consumer(serviceName);
        	PersistenceManager pm = PMF.get().getPersistenceManager();
        	try
        	{
        		pm.makePersistent(consumer);
        	}
        	catch (Exception e)
        	{
        		//TODO: log error
        	}
        	finally
        	{
        		;
        	}
        	req.setAttribute("msg", "Added consumer service " + serviceName);
        	String uploadURL = "/consumer";
        	req.setAttribute("ulu", uploadURL);
            UserService userService = UserServiceFactory.getUserService();
        	req.setAttribute("lou", userService.createLogoutURL(req.getRequestURI()));
        	handleJSPForward("/consumers.jsp", req, resp);
        }
	}
}
