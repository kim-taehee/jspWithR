<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%
response.setHeader("Content-Disposition", "attachment; filename=excel.xls");
response.setHeader("Content-Description", "JSP Generated Data");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%request.setCharacterEncoding("UTF-8");%>
<%
String num = (String)pageContext.getSession().getAttribute("pData");
%>
    <hr>
	<h1>forward action �� sendRedirect()</h1>
    <hr>
    	���� ���̴� ȭ���� page_control_end.jsp ���� ����� ����Դϴ�.
    <hr>
 
<%= num %>

   	 


</body>
</html>