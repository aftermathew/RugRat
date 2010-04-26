<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.bitsyrup.rugrat.common.PMF, com.bitsyrup.rugrat.common.Administrator" %>
<%@ page import="javax.jdo.PersistenceManager, java.util.List" %>
<%
 	String msg = (String)request.getAttribute("msg");  
	PersistenceManager pm = PMF.get().getPersistenceManager();
	String query = "select from " + Administrator.class.getName();
	List<Administrator> admins = (List<Administrator>)pm.newQuery(query).execute();
	pm.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin</title>
</head>
<body>
<%@ include file="protectedpage.jspf" %>
	<h3><%= null == msg ? "" : msg %></h3>
	<h2>Listing current admins:</h2>
	<table border="1px black">
		<thead>
			<tr>
				<th>Name</th>
				<th>Email</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<tr><td>Demi Raven</td><td>demiraven@gmail.com</td><td>&nbsp;</td></tr>
			<tr><td>Mathew Chasan</td><td>aftermathew@gmail.com</td><td>&nbsp;</td></tr>
			<% if (admins.size() > 0) { 
				for (int i = 0; i < admins.size(); i++) {
					Administrator admin = admins.get(i);
			%>
			<tr>
				<td><%= admin.getName() %></td>
				<td><%= admin.getEmail() %></td>
				<td><a href="/admin?verb=delete&key=<%= admin.getEmail() %>" onclick="return confirm('Are you certain?');">delete</a></td>
			</tr>
			<% } } %>
		</tbody>
	</table>	
	<h3>Add new admin:</h3>
	<form action="<%= request.getAttribute("ulu") %>" method="post">
		email: <input type="text" name="email" /> <br/>
		name: <input type="text" name="name" />
		<input type="submit" value="Submit" />
	</form>
	<p>Or you can <a href="<%= request.getAttribute("lou") %>">sign out</a>.</p>
	
	<%@ include file="navigation.jspf" %>
</body>
</html>