 <%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.DataOutputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.net.ssl.HttpsURLConnection" %>

<jsp:useBean id="membermanager" class="member.MemberManager"/>

<%		
		if( session==null || !request.isRequestedSessionIdValid()){
		 response.sendRedirect("/RPA/login/login.jsp");
		 }else{}
%>
<%
	   //String REMOTE_ADDR = request.getRemoteAddr();
	   //if (!"172.20.28.175".equals(REMOTE_ADDR) && !"172.20.28.74".equals(REMOTE_ADDR) && !"172.20.29.79".equals(REMOTE_ADDR)) return;
%>


<!DOCTYPE html>
<html>
<head>
    <title>RPA System</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <link rel="stylesheet" href="StyleSheet3.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <!--Font Awesone 4 for icon-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="Script4.js"></script>
    <script type="text/javascript" src="jquery.table2excel.js"></script>
</head>
<body>
    <nav>
     	<a href="login/login_out.jsp">Logout</a> |
        <a href="https://ep.halla.com" target="_blank">Mando</a> |
        <a href="http://gplm.halla.com/Windchill/extcore/mando/pms/common/menu/index.jsp" target="_blank">iPCS</a>
    </nav>

    <div class="header">
        <p class="title">EBS 사양 관리 시스템</p>
    </div>

    <div class="button">
    	<form class="button" action="download.jsp" method="post" enctype="Multipart/form-data" target="iframe">
    		<button class="btn" ><i class="fa fa-download"></i> Download</button>
    		<iframe src="#" name="iframe" style="width:1px; height:1px; border:0; visibility:hidden;"></iframe>       
    	</form>  
    </div>
    
    <div class="flex-container">
        <div style="flex-grow:3">
            <h2>BOM</h2>
            <form class="part-search" action="getBOM.jsp" method="post" target="iframe">
                <input id="pnSearch" type="text" placeholder="Part No." name="partNo">
                <input id="Request" type="submit" value="Request">
            </form>
            <iframe src="#" name="iframe" style="width:1px; height:1px; border:0; visibility:hidden;"></iframe>

        </div>
        <div style="flex-grow:3">
            <h2>Barcode</h2>
            <form class="part-search" action="barUpload.jsp" method="post" enctype="Multipart/form-data" target="iframe" >
                <input id="bfilepath" type="text" placeholder="Choose File" onclick="javascript:document.getElementById('bfile').click();">
                <input id="bfile" type="file" style='visibility: hidden;' name="img" onchange="ChangeText(this, 'bfilepath', 'bfullpath');" />
                <input id="Request" type="submit" value="upload" >  
                
            </form>
            <iframe src="#" name="iframe" style="width:1px; height:1px; border:0; visibility:hidden;"></iframe>

        </div>
        <div style="flex-grow:3">
            <h2>ECU</h2>
            <form class="part-search" action="ecuUpload.jsp" method="post" enctype="Multipart/form-data" target="iframe">
                <input id="efilepath" type="text" placeholder="Choose File" onclick="javascript:document.getElementById('efile').click();">
                <input id="efile" type="file" style='visibility: hidden;' name="img" onchange="ChangeText(this, 'efilepath', 'efullpath');" />
                <input id="Request" type="submit" value="upload">
                
            </form>
            <iframe src="#" name="iframe" style="width:1px; height:1px; border:0; visibility:hidden;"></iframe>          
        </div>
    </div>

    <footer>
        <p>ⓒ Advanced MFG Engineering Team</p>
    </footer>
 <p id="bfullpath" style='visibility: hidden;'></p>
 <p id="efullpath" style='visibility: hidden;'></p>   
</body>

</html>