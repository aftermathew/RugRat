<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Upload Assets</title>
</head>
<body>
	<form action="<%= request.getAttribute("ulu") %>" method="post" enctype="multipart/form-data">
		<input type="file" name="asset" />
		<input type="submit" value="Submit" />
	</form>
	<p>Or you can <a href="<%= request.getAttribute("lou") %>">sign out</a>.</p>
</body>
</html>