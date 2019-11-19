<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="membermanager" class="member.MemberManager"/>

<%
    // 0: 인증 가능 사용자 및 비밀번호 목록.
    String[] users = { "mando", "mando1"};  //인증된 사용자 
    String[] passwords = { "mando", "mando" };

    // 1: form 으로부터 전달된 데이터를 변수에 저장.
    String id = request.getParameter("id");
    String pass = request.getParameter("passwd");
	String name = membermanager.login(id, pass);

    // 2: 사용자 인증
    String redirectUrl = "login.jsp"; // 인증 실패시 재요청 될 url 

    for (int i = 0; i < users.length; i++) {
        if (users[i].equals(id) && passwords[i].equals(pass)) {
            session.setAttribute("idKey", id); // 인증되었음 세션에 남김
            redirectUrl = "../ABS_RPA.jsp"; // 인증 성공 시 재요청 url
        }
    }

    response.sendRedirect(redirectUrl);
%>
