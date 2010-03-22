package com.bitsyrup.rugrat.common;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class auth {

	private static String[] devs;
	
	static 
	{
		devs = new String[]{"demiraven@gmail.com", "aftermathew@gmail.com"};
	}
	
	public static boolean isAuthorized()
	{
        UserService userService = UserServiceFactory.getUserService();
        String email = userService.getCurrentUser().getEmail();
		for (int i = 0; i < devs.length; i++)
		{
			if (devs[i].compareToIgnoreCase(email) == 0)
				return true;
		}
		//then iterate through additional known admin list.
		return false;
	}
}
