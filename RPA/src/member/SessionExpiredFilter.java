package member;


import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.*;
import javax.servlet.http.*;


public class SessionExpiredFilter implements Filter {  
	
		private String page = "login.jsp";  
		private Connection con = null;
		
		// 간단하게 DB 연결 해봤음.
	public SessionExpiredFilter() {
		String url = "jdbc:mysql://localhost:1234/test";
		String id = "root";
		String pwd = "root1234";

		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			con = (Connection) DriverManager.getConnection(url, id, pwd);
		} catch (Exception e) {
		}
	}
	
	
	
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {  
		
		HttpServletRequest request = (HttpServletRequest) req ;
		HttpServletResponse response = (HttpServletResponse) res;
		RequestDispatcher rd = request.getRequestDispatcher(page);  
		
		if(excludeUrl(request,response)) {  
			rd.forward(request, response);  
		} else {  
			chain.doFilter(request, response);  
		}  
	}  
	
	
	
	
	private boolean excludeUrl(HttpServletRequest request, HttpServletResponse response) {
		RequestDispatcher rd = request.getRequestDispatcher(page);  
		String uri = request.getRequestURI().toString().trim();
		
	
		if(uri.startsWith("/MDMserver/jsp/sign/")){
		// sign 쪽이면 세션,토큰 겁사없이 진행
		return false;
		}else{
		// 그 외의 영역에서는 세션과 토큰 검사 후 진행
		// session이 null이면 로그인으로 이동
		HttpSession session = request.getSession();
		if (session.getAttribute("accessToken") == null) {
		// System.out.println("세션없음");
		return true;
		} else {
		// System.out.println("세션있음");
		}
	
	
	// 토큰이 null이면 로그인으로 이동
		String accessToken = "";
	
		if (session.getAttribute("accessToken") != null) {
		accessToken = session.getAttribute("accessToken").toString();
		} else {
		return true;
		}
		
		try {
		Statement stat = (Statement) con.createStatement();
		String sql = String.format("SELECT COUNT(account) AS account FROM tbl_user WHERE access_token = '%s'", accessToken);
		ResultSet rs = stat.executeQuery(sql);
	
			if (rs.next()) {
				if (rs.getString("account").equals("1")) {
				// System.out.println("토큰있음");
				} else {
				// System.out.println("토큰없음");
				return true;
				}
			}
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
		}
	
	}
	
	
	
	
	public void destroy() {  
	}  
	
	  
	
	public void init(FilterConfig filterConfig) throws ServletException {  
	
		if(filterConfig.getInitParameter("page") != null) {  
			page = filterConfig.getInitParameter("page");  
		}	  
	
	}  
	
}  