<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Iterator, java.util.Date" %>
<%@ page import="com.bitsyrup.rugrat.common.assets.*, com.google.appengine.api.blobstore.*" %>

<%
	BlobInfoFactory infoFact = new BlobInfoFactory();
	Iterator<BlobInfo> blobInfos = infoFact.queryBlobInfos();
	AssetList al = new AssetList();
	while (blobInfos.hasNext()) {
		BlobInfo info = blobInfos.next();
		String blobKey = info.getBlobKey().getKeyString();
		String blobName = info.getFilename();
		Date blobDate = info.getCreation();
		Long blobSize = info.getSize();			
		String blobType = info.getContentType();
		Asset asset = new Asset(blobName, blobKey, blobDate, blobSize, blobType);
		al.add(asset);
	}
	String order = request.getParameter("orderby");
	if (null == order || order.isEmpty())
		order = "date";
	al.sort(order);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Asset Listing</title>
</head>
<body>
	<h2>Listing current assets:</h2>
	<table border="1px black">
		<thead>
			<tr>
				<th><a href="/assets?order=name">Name</a></th>
				<th><a href="/assets?order=date">Date (GMT)</a></th>
				<th><a href="/assets?order=size">File Size (KB)</a></th>
				<th><a href="/assets?order=type">Content Type</a></th>
			</tr>
		</thead>
		<tbody>
		<% 
		if (al.size() > 0) {
			Iterator<Asset> iter = al.iterator();
			while (iter.hasNext()) {
				Asset asset = iter.next();
		%>
			<tr>
				<td><%= asset.getName() %></td>
				<td><%= asset.getCreatedShortString() %></td>
				<td><%= asset.getSize() / 1024 %></td>
				<td><%= asset.getContentType() %></td>
			</tr>
		<%
			}
		}
		%>
		</tbody>
	</table>
</body>
</html>