<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.bitsyrup.rugrat.common.PMF, com.bitsyrup.rugrat.common.Consumer" %>
<%@ page import="javax.jdo.PersistenceManager, java.util.List" %>
<%
 	String msg = (String)request.getAttribute("msg");  
	PersistenceManager pm = PMF.get().getPersistenceManager();
	String query = "select from " + Consumer.class.getName();
	List<Consumer> consumers = (List<Consumer>)pm.newQuery(query).execute();
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
	<h2>Listing current consumers:</h2>
	<table border="1px black">
		<thead>
			<tr>
				<th>Service</th>
				<th>Key</th>
				<th>Secret</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<% if (consumers.size() > 0) { 
				for (int i = 0; i < consumers.size(); i++) {
					Consumer consumer = consumers.get(i);
			%>
			<tr>
				<td><%= consumer.getName() %></td>
				<td><%= consumer.getKey() %></td>
				<td><%= consumer.getSecret() %></td>
				<td><a href="/consumer?verb=delete&key=<%= consumer.getKey() %>" onclick="return confirm('Are you certain?');">delete</a></td>
			</tr>
			<% } } %>
		</tbody>
	</table>	
	<h3>Add new service:</h3>
	<form action="<%= request.getAttribute("ulu") %>" method="post">
		service name: <input type="text" name="name" />
		<input type="submit" value="Submit" />
	</form>
	<p>Or you can <a href="<%= request.getAttribute("lou") %>">sign out</a>.</p>
	
	<%@ include file="navigation.jspf" %>
</body>
</html>
<%
	pm.close();
%>