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
		
		// �����ϰ� DB ���� �غ���.
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
		// sign ���̸� ����,��ū �̻���� ����
		return false;
		}else{
		// �� ���� ���������� ���ǰ� ��ū �˻� �� ����
		// session�� null�̸� �α������� �̵�
		HttpSession session = request.getSession();
		if (session.getAttribute("accessToken") == null) {
		// System.out.println("���Ǿ���");
		return true;
		} else {
		// System.out.println("��������");
		}
	
	
	// ��ū�� null�̸� �α������� �̵�
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
				// System.out.println("��ū����");
				} else {
				// System.out.println("��ū����");
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