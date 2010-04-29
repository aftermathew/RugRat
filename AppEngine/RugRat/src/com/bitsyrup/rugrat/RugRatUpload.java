package com.bitsyrup.rugrat;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.users.*;
import com.google.appengine.api.blobstore.*;

import com.bitsyrup.rugrat.common.*;


@SuppressWarnings("serial")
public class RugRatUpload extends HttpServlet {
	
	//single instance - expensive!
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	//logger
    private static final Logger log = Logger.getLogger(RugRatUpload.class.getName());


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
        		String blobKeyParam = req.getParameter("blob-key");
        		if (blobKeyParam != null)
        		{
        			//TEST: prove that we get a blob key following upload...
        			resp.getWriter().println("TEST: blob key = " + blobKeyParam + "\n");

        			/*BlobInfoFactory infoFact = new BlobInfoFactory();
        			Iterator<BlobInfo> infoIter = infoFact.queryBlobInfos();
        			while (infoIter.hasNext())
        			{
        				BlobInfo info = infoIter.next();
        				resp.getWriter().println("\tItem: " + info.getFilename() + " [" + info.getBlobKey().getKeyString() + "] (" + info.getContentType() + 
        						", " + info.getSize() + ", " + info.getCreation().toString() + ")\n");
        			}*/
        		}
        		else
        		{
		        	//call jsp, passing in this url as upload POST
		        	String uploadURL = blobstoreService.createUploadUrl(req.getRequestURI());
		        	String logoutURL = userService.createLogoutURL(thisURL);
		        	req.setAttribute("ulu", uploadURL);
		        	req.setAttribute("lou", logoutURL);
		        	handleJSPForward("/upload.jsp", req, resp);
        		}
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
	@SuppressWarnings("unchecked")
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
            //NOTE: the post requires a redirect following...
            for (Enumeration<String> names = req.getParameterNames(); names.hasMoreElements(); )
            {
            	String name = (String)names.nextElement();
            	log.info("upload post param: " + name);
            }
        	if (blobKey == null) {
                resp.sendRedirect("/assets");
            } else {
                resp.sendRedirect("/assets?blob-key=" + blobKey.getKeyString() + "&file=" + req.getParameter("asset"));
            }
        }
	}
}
