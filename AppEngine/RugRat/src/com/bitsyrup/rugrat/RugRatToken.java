package com.bitsyrup.rugrat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Token;
import com.bitsyrup.rugrat.common.auth;
import com.bitsyrup.rugrat.common.oauth;
import com.bitsyrup.rugrat.common.utility;
import com.bitsyrup.rugrat.xmlserializable.ErrorResponse;
import com.bitsyrup.rugrat.xmlserializable.TokenRequest;
import com.bitsyrup.rugrat.xmlserializable.TokenResponse;

//NOTE: this is all under HTTPS, see web.xml

/*********************
 * XML description
 * 
 * for auth request (POST):
 * <tokenRequest>
 *     <digest>[Base 64 encoded name:password]</digest>
 * </tokenRequest>
 * 
 * for auth response (POST):
 * <tokenResponse>
 *     <name>[user name]</name>
 *     <token>[oauth token]</token>
 *     <tokenSecret>[oauth token secret]</tokenSecret>
 * <tokenResponse>
 * 
 * for error response (POST):
 * <error>
 *     <message>[error message]</message>
 *     <code>[error code (optional)]</errorCode>
 * </error>
 * 
 */

@SuppressWarnings("serial")
public class RugRatToken extends HttpServlet {

	//logger
    private static final Logger log = Logger.getLogger(RugRatAssets.class.getName());
	
    //token request
	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException 
	{
		oauth.OAUTH_RESULT result = oauth.verifyOAuth(req, false);
		
		if (result == oauth.OAUTH_RESULT.SUCCESS)
		{
			//success.  create new token, token secret for user
			//	return xml TokenResponse
			String consumerKey = oauth.getOAuthValue(req, "oauth_consumer_key");
			//get username and password from request body - verify user
			BufferedReader br = req.getReader();
			StringBuilder sb = new StringBuilder();
			String line = br.readLine();
			while (line != null)
			{
				sb.append(line + "\n");
				line = br.readLine();
			}
			TokenRequest treq = new TokenRequest(sb.toString());
			String[] idpass = treq.getDigest().split(":");
			//hash password, verify user against database
			String username = idpass[0];
			String passhash = new String(utility.base64Encode(utility.hashSHA1(idpass[1] + utility.HASHSALT)));
			if (auth.isAuthorizedUser(username, passhash))
			{
				PersistenceManager pm = PMF.get().getPersistenceManager();
				String query = "select from " + com.bitsyrup.rugrat.common.Token.class.getName() + 
					" where userID == '" + username + "' && consumerKey == '" + consumerKey + "'";
				List<Token> tokens = (List<Token>) pm.newQuery(query).execute();
				Token token = null;
				if (tokens.size() > 0)
				{
					//return existing token
					token = tokens.get(0);
				}
				else
				{
					//create new token
					token = new Token(username, consumerKey);
					token.persist();
				}
				TokenResponse tresp = new TokenResponse(token.getUserID(), token.getToken(), token.getTokenSecret());
				String xml = tresp.toXML();
				resp.setStatus(200);
				resp.getWriter().write(xml);
			}
			else
			{
				PrintWriter writer = resp.getWriter();
				ErrorResponse error = new ErrorResponse(
						String.valueOf(401),
						"Invalid credentials");
				resp.setStatus(401);
				writer.write(error.toXML());
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

