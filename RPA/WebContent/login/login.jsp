<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	 String id = (String) session.getAttribute(null);
	// System.out.println(id);
	session.invalidate(); 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Malgun Gothic';
        }
        
	    .header {
		    font-size: 40px;
		    font-weight: bold;
		    text-align:center;
		    color: #0e4194;
		    height: 50px;
		}

        input[type=text], input[type=password] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        
        input[type="text"]:focus {
            border-color: dodgerBlue;
        }
        
        input[type="password"]:focus {
            border-color: dodgerBlue;
        }

        #btnLogin {
            background-color: #e4e4e4;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 100%;
            font-size: larger;
        }

        #btnLogin:hover {
           background-color: dodgerBlue;
        }

        .container {
            padding: 50px 50px 50px 100px;
            width: 300px;
            left: 600px;
        }

        span.psw {
            float: right;
            padding-top: 16px;
        }
    </style>
	<title>사용자 로그인</title>
	<script src="../js/script.js"></script>
	<script type="text/javascript">
		window.onload = function() {
			document.getElementById("btnLogin").onclick = funcLogin;
			document.getElementById("btnHome").onclick = funcHome;
		}
	</script>
</head>
<body>
    <div class="header">
        <p class="title">EBS 사양 관리 시스템</p>
    </div>
	<div class="container">
		<form class="form-signin" name="loginForm"> 
			<%if(id == null || id == ""){ %>      
	    		<h2>Login </h2>
	    		<label for="uname"><b>Username</b></label>
	    		<input type="text" name="id" placeholder="Login ID" required>
	    		<label for="psw"><b>Password</b></label>
	    		<input type="password" name="passwd" placeholder="Password" required=>      
	      		<input type="button" value="Login" id="btnLogin">   
	    	<%} else { 
	            String redirectUrl = "../ABS_RPA.jsp"; // 인증 성공 시 재요청 url
	    		response.sendRedirect(redirectUrl);
			} %>
	    </form>
	</div>

</body>
</html>