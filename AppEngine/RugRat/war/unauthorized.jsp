<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Not Authorized</title>
</head>
<body>
	<p>Sorry, you are not authorized.</p>
	<p>You can <a href="<%= request.getAttribute("lou") %>">sign out, however</a>.</p>
</body>
</html>