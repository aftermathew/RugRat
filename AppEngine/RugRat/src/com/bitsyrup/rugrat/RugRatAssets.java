//For listing and manipulation of blobstore assets

package com.bitsyrup.rugrat;

import java.io.IOException;
import java.util.Iterator;
//import java.util.logging.Level;
//import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitsyrup.rugrat.common.auth;
import com.bitsyrup.rugrat.common.oauth;
import com.bitsyrup.rugrat.common.Ticket;
import com.bitsyrup.rugrat.common.oauth.OAUTH_RESULT;
import com.google.appengine.api.blobstore.*;
import com.google.appengine.api.users.*;


@SuppressWarnings("serial")
public class RugRatAssets extends HttpServlet {
	//single instance - expensive!
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
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
	

	//logger
    //private static final Logger log = Logger.getLogger(RugRatAssets.class.getName());
	
	private void doDataResponse(String key, HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		if (null == key)
		{
			handleJSPForward("/bloblist.jsp", req, resp);
		}
		else
		{
			BlobInfoFactory infoFact = new BlobInfoFactory();
			Iterator<BlobInfo> blobInfos = infoFact.queryBlobInfos();
			while(blobInfos.hasNext())
			{
				BlobInfo info = blobInfos.next();
				if (info.getBlobKey().getKeyString().compareTo(key) == 0 ||
						info.getFilename().compareTo(key) == 0)
				{
					BlobKey blobKey = new BlobKey(info.getBlobKey().getKeyString());
					blobstoreService.serve(blobKey, resp);
					return;
				}
			}
			resp.setStatus(404);
		}
	}
    
	//entry GET
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
    	String pathInfo = req.getPathInfo();   
    	String authHeader = req.getHeader("Authorization");
    	String ticketVal = req.getParameter("ticket");
		if (null != authHeader && !authHeader.isEmpty())
		{
			//this is the API case...
			if (OAUTH_RESULT.SUCCESS == oauth.verifyOAuth(req, true))
			{
				if (null != pathInfo)
				{
					pathInfo = pathInfo.substring(1);
					//this is /assets/<KEY> case
					//	respond with data corresponding with key
					doDataResponse(pathInfo, req, resp);
				}
			}
			return; //no further response...
		}
		else if (null != ticketVal && !ticketVal.isEmpty())
		{
			
			//handle possibility that there is no oauth,
			//	but the user has instead acquired a media ticket...
			if (Ticket.isValidTicket(ticketVal))
			{
				if (null != pathInfo)
				{
					pathInfo = pathInfo.substring(1);
					doDataResponse(pathInfo, req, resp);
					return;
				}
			}
		}
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
        		if (null == verb)
        		{
        			String blobKey = req.getParameter("blob-key");
        			if (null != blobKey && !blobKey.isEmpty())
        			{
        				req.setAttribute("bk", blobKey);
        			}
        			if (null != pathInfo)
        			{
        				pathInfo = pathInfo.substring(1);
        				//this is /assets/<KEY> case
        				//	respond with data corresponding with key
        				doDataResponse(pathInfo, req, resp);
        				return; //no further response...
        			}
        		}
        		else
        		{
        			//handle deletion of particular blob referenced by key string
        			if (verb.compareTo("delete") == 0)
        			{
        				String key = req.getParameter("key");
        				if (null != key)
        				{
        					BlobInfoFactory infoFact = new BlobInfoFactory();
        					Iterator<BlobInfo> blobInfos = infoFact.queryBlobInfos();
        					while(blobInfos.hasNext())
        					{
        						BlobInfo info = blobInfos.next();
        						if (info.getBlobKey().getKeyString().compareTo(key) == 0)
        						{
        							blobstoreService.delete(info.getBlobKey());
        							break;
        						}
        					}
        				}
        			}
        		}
        		//forward the parameters as attributes
        		req.setAttribute("order", req.getParameter("order"));
        		if (req.getParameter("dir") != null)
        			req.setAttribute("dir", req.getParameter("dir"));
        		handleJSPForward("/bloblist.jsp", req, resp);
        	}
        	else
        	{
        		String logoutURL = userService.createLogoutURL(thisURL);
        		req.setAttribute("lou", logoutURL);
	        	handleJSPForward("/unauthorized.jsp", req, resp);
        	}
        }
	}
	
	
}
