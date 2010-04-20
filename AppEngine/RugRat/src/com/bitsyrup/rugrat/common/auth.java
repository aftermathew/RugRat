package com.bitsyrup.rugrat.common;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.jdo.PersistenceManager;

import com.bitsyrup.rugrat.common.PMF;
import com.bitsyrup.rugrat.common.Administrator;

import java.util.List;

public class auth {

	private static String[] devs;
	
	static 
	{
		devs = new String[]{"demiraven@gmail.com", "aftermathew@gmail.com"};
	}
	
	@SuppressWarnings("unchecked")
	public static boolean isAuthorized()
	{
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (null == user)
        	return false;
        String email = user.getEmail();
		for (int i = 0; i < devs.length; i++)
		{
			if (devs[i].compareToIgnoreCase(email) == 0)
				return true;
		}
		//then iterate through additional known admin list.
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Administrator.class.getName();
		List<Administrator> admins = (List<Administrator>)pm.newQuery(query).execute();
		for (int i = 0; i < admins.size(); i++)
		{
			if (admins.get(i).getEmail().compareTo(email) == 0)
				return true;
		}
		return false;
	}
}
