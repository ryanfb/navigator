<%@ page language="java"%>
<%@ page session="false" contentType="text/html" import="info.papyri.data.APISIndices,info.papyri.portlet.*,org.apache.lucene.document.*,org.apache.lucene.search.*,java.util.*,javax.portlet.*" %>
<%@ taglib uri="http://java.sun.com/portlet" 
prefix="portlet"%><portlet:defineObjects/><%String apisId = request.getParameter("controlName").trim();%>
<div class="pn-ddbdp-data" style="height:50px;">
<table class="metadata">
<tr><td style="text-align:center;font-weight:bold;"><%=apisId %> does not appear to have a Duke Databank transcription.</td></tr>
</table>
</div>