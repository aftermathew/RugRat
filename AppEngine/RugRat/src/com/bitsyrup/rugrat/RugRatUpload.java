package com.bitsyrup.rugrat;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.*;

import com.google.appengine.api.users.*;
import com.google.appengine.api.blobstore.*;

import com.bitsyrup.rugrat.common.*;

@SuppressWarnings("serial")
public class RugRatUpload extends HttpServlet {
	
	//single instance - expensive!
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

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
        	if (auth.isAuthorized())
        	{
        		String blobKeyParam = req.getParameter("blob-key");
        		if (blobKeyParam != null)
        		{
        			resp.getWriter().println("blob key: " + blobKeyParam);
        		}
        		else
        		{
		        	//call self as POST
	        		//TODO: pull this into a jsp
		        	String uploadURL = blobstoreService.createUploadUrl(req.getRequestURI());
		        	//String uploadURL = "/upload";
		        	PrintWriter respWriter = resp.getWriter();
		        	respWriter.print("<html>\n\t<head>\n\t\t<title>Upload Assets</title>\n\t</head>");
		        	respWriter.print("\n\t<body>");
		        	respWriter.print("\n\t\t<form action=\"");
		        	respWriter.print(uploadURL);
		        	respWriter.print("\" method=\"post\" enctype=\"multipart/form-data\">");
		        	respWriter.print("\n\t\t\t<input type=\"file\" name=\"asset\" />");
		        	respWriter.print("\n\t\t\t<input type=\"submit\" value=\"Submit\" />");
		        	respWriter.print("\n\t\t</form>");
		        	respWriter.print("\n\t\t<p>Or you can <a href=\"" + 
		        			userService.createLogoutURL(thisURL) +
		                    "\">sign out</a>.</p>");
		        	respWriter.print("\n\t</body>");
		        	respWriter.print("\n</html>");
        		}
        	}
        	else
        	{
        		resp.getWriter().print("<html><head><title>Not Authorized</title></head>");
        		resp.getWriter().println("<p>Sorry, you are not authorized.</p>");
        		resp.getWriter().print("\n\t\t<p>You can <a href=\"" + 
	        			userService.createLogoutURL(thisURL) +
	                    "\">sign out, however</a>.</p>");
        		resp.getWriter().print("</html");
        	}
        }
	}
	
	//binary upload post
	//@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		UserService userService = UserServiceFactory.getUserService();
        if (userService.getCurrentUser() == null)
        {
        	//on auth fail, send GET to this page
        	resp.sendRedirect("upload");
        }
        else
        {
        	//NOTE: not concerned about auth, since the uploading is done through POST to service.
        	//	this is a rerouting from the service, after upload.
        	resp.getWriter().println("uploaded.");
        	Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
            BlobKey blobKey = blobs.get("asset");
            //NOTE: the post requires a redirect folling the logic
        	if (blobKey == null) {
                resp.sendRedirect("/");
            } else {
                resp.sendRedirect("/upload?blob-key=" + blobKey.getKeyString());
            }
        }
	}
}
