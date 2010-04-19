//For listing and manipulation of blobstore assets

package com.bitsyrup.rugrat;

import java.io.IOException;
import java.util.Iterator;
//import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitsyrup.rugrat.common.auth;
import com.google.appengine.api.blobstore.*;
import com.google.appengine.api.users.*;

@SuppressWarnings("serial")
public class RugRatAssets extends HttpServlet {

	//single instance - expensive!
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	//logger
    //private static final Logger log = Logger.getLogger(RugRatAssets.class.getName());
	
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
        	if (auth.isAuthorized())
        	{
        		String verb = req.getParameter("verb");
        		if (null == verb)
        		{
        			String blobKey = req.getParameter("blob-key");
        			if (null != blobKey && !blobKey.isEmpty())
        			{
        				req.setAttribute("bk", blobKey);
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
