package com.bitsyrup.rugrat.common;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Administrator;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.util.List;

import javax.jdo.PersistenceManager;


public class auth {

	private static String[] devs;

	static 
	{
		devs = new String[] { "demiraven@gmail.com", "aftermathew@gmail.com" };
	}

	// checks authorized ADMIN user for cloud service
	// used within the AppEngine site directly
	@SuppressWarnings("unchecked")
	public static boolean isAuthorizedAdmin() 
	{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (null == user) 
		{
			return false;
		}
		String email = user.getEmail();
		for (int i = 0; i < devs.length; i++)  
		{
			if (devs[i].compareToIgnoreCase(email) == 0) 
			{
				return true;
			}
		}
		// then iterate through additional known admin list.
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Administrator.class.getName();
		List<Administrator> admins = (List<Administrator>) pm.newQuery(query).execute();
		for (int i = 0; i < admins.size(); i++) 
		{
			if (admins.get(i).getEmail().compareToIgnoreCase(email) == 0) 
			{
				return true;
			}
		}
		return false;
	}
}
