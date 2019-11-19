<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout</title>
</head>
<body>


	<% 
	String s_name;
	String s_value;
 	Enumeration enum_app = session.getAttributeNames();
    
    int i = 0;
    
    while (enum_app.hasMoreElements()) {
        
        i++;
        s_name = enum_app.nextElement().toString();
        s_value = session.getAttribute(s_name).toString();
        
    }
    session.invalidate();
    // session.removeAttribute("idKey");

	%>
	<script type="text/javascript">
		alert("로그아웃 성공");
		window.location.replace("login.jsp");
	</script>
</body>
</html>