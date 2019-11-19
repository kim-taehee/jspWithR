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
	<h1>forward action 및 sendRedirect()</h1>
    <hr>
    	지금 보이는 화면은 page_control_end.jsp 에서 출력한 결과입니다.
    <hr>
 
<%= num %>

   	 


</body>
</html>