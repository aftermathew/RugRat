package com.bitsyrup.rugrat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.*;

import com.bitsyrup.rugrat.common.User;
import com.bitsyrup.rugrat.common.oauth;
import com.bitsyrup.rugrat.common.oauth.OAUTH_RESULT;
import com.bitsyrup.rugrat.xmlserializable.ErrorResponse;
import com.bitsyrup.rugrat.xmlserializable.UserRequest;

//NOTE: this is all under HTTPS, see web.xml

/*********************
 * XML description
 * 
 * for user add (POST):
 * <userAddRequest>
 *     <user>
 *     		<name>[user's name (or identifier)]</name>
 *     		<email>[user's email]</email>
 *     		<password>[user's password (over HTTPS)]</password>
 *     </user>
 * </userAddRequest>
 * 
 */

@SuppressWarnings("serial")
public class RugRatUser extends HttpServlet {

	//logger
    private static final Logger log = Logger.getLogger(RugRatAssets.class.getName());
	
	//add new user
	//@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		oauth.OAUTH_RESULT result = oauth.verifyOAuth(req, false);
		
		if (result == oauth.OAUTH_RESULT.SUCCESS)
		{
			BufferedReader br = req.getReader();
			StringBuilder sb = new StringBuilder();
			String line = br.readLine();
			while (line != null)
			{
				sb.append(line + "\n");
				line = br.readLine();
			}
			UserRequest ureq = new UserRequest(sb.toString());
			if (ureq.getPasswordHash().isEmpty() || ureq.getEmail().isEmpty())
			{
				PrintWriter writer = resp.getWriter();
				ErrorResponse error = new ErrorResponse(
						String.valueOf(OAUTH_RESULT.INVALID_REQUEST_DATA.ordinal()), 
						"OAuth request error: bad format in body XML");
				resp.setStatus(403);
				writer.write(error.toXML());
			}
			else
			{
				User user = new User(ureq.getName(), ureq.getEmail(), ureq.getPasswordHash());
				try
				{
					user.persist();
					resp.setStatus(201);
				}
				catch (Exception e)
				{
					PrintWriter writer = resp.getWriter();
					ErrorResponse error = new ErrorResponse(
							String.valueOf(OAUTH_RESULT.INVALID_REQUEST_DATA.ordinal()), 
							"OAuth request error: " + e.getMessage());
					resp.setStatus(403);
					writer.write(error.toXML());
				}
			}
		}
		else
		{
			log.log(Level.WARNING, "Received OAuth token request failure: " + result.toString());
			PrintWriter writer = resp.getWriter();
			ErrorResponse error = new ErrorResponse(
					String.valueOf(result.ordinal()), 
					"OAuth request failure: " + result.toString());
			resp.setStatus(401);
			writer.write(error.toXML());
		}
	}
}
