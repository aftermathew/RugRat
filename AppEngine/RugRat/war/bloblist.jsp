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
	String order = request.getParameter("order");
	String dir = request.getParameter("dir");
	String msg = request.getParameter("msg");
	if (order == null || order.isEmpty())
		order = "date";
	al.sort(order);
	if (dir != null)
		al.reverse();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Asset Listing</title>
</head>
<body>
<%@ include file="protectedpage.jspf" %>
	<h3 class="message"><%= msg == null ? "" : msg %></h3> 
	<h2>Listing current assets:</h2>
	<table border="1px black">
		<thead>
			<tr>
				<th><a href="/assets?order=name<%= order.compareTo("name") != 0 ? "" : dir == null ? "&dir=rev" : "" %>">Name</a></th>
				<th><a href="/assets?order=date<%= order.compareTo("date") != 0 ? "" : dir == null ? "&dir=rev" : "" %>">Date (GMT)</a></th>
				<th><a href="/assets?order=size<%= order.compareTo("size") != 0 ? "" : dir == null ? "&dir=rev" : "" %>">File Size (KB)</a></th>
				<th><a href="/assets?order=type<%= order.compareTo("type") != 0 ? "" : dir == null ? "&dir=rev" : "" %>">Content Type</a></th>
				<th>&nbsp;</th>
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
				<% 
					String asset_link = "\"/assets/" + asset.getKey() + "\""; 
					String asset_name = asset.getName();
				%>
				<td><a href=<%= asset_link %>><%= asset_name %></a></td>
				<td><%= asset.getCreatedShortString() %></td>
				<td><%= asset.getSize() / 1024 %></td>
				<td><%= asset.getContentType() %></td>
				<td><a href="/assets?verb=delete&key=<%= asset.getKey() %>" onclick="return confirm('Are you certain?');">delete</a></td>
			</tr>
		<%
			}
		}
		%>
		</tbody>
	</table>
<%@ include file="navigation.jspf" %>
</body>
</html>