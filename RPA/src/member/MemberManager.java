package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberManager {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private DataSource ds;
	

	public boolean checkId(String id){
		boolean b = false;
		try {
			String sql = "select id from webshop_member where id like ?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			b=rs.next();
		} catch (Exception e) {
			System.out.println("checkId err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return b;
	}
	

	
	
	//�쉶�썝媛��엯
	public boolean insertData(MemberBean bean){
		boolean b = false;
		try {
			String sql = "insert into webshop_member values(?,?,?,?,?,?,?,?)";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getId());
			pstmt.setString(2, bean.getName());
			pstmt.setString(3, bean.getPass());
			pstmt.setString(4, bean.getMail());
			pstmt.setString(5, bean.getPhone());
			pstmt.setString(6, bean.getZipcode());
			pstmt.setString(7, bean.getAddress());
			pstmt.setString(8, bean.getJob());
			if(pstmt.executeUpdate()>0)b=true;
			
		} catch (Exception e) {
			System.out.println("insertData err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return b;
	}
	
	//濡쒓렇�씤�슜 �뜲�씠�꽣 �깘�깋
	public String login(String id, String pass){
		String str="";
		try {
			String sql = "select id, name from webshop_member where id=? and pass=?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pass); 
			rs = pstmt.executeQuery();
			if(rs.next()) str=rs.getString("name");

		} catch (Exception e) {
			System.out.println("login err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return str;
	}
	
	//�쉶�썝 �닔�젙 - �쉶�썝 �젙蹂� 媛����삤湲�
	public MemberDto getData(String id){
		MemberDto dto = null;
		try {
			String sql = "select id, pass, name, mail, phone, zipcode, address, job from webshop_member where id like ?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				dto = new MemberDto();
				dto.setId(rs.getString("id"));
				dto.setPass(rs.getString("pass"));
				dto.setName(rs.getString("name"));
				dto.setMail(rs.getString("mail"));
				dto.setPhone(rs.getString("phone"));
				dto.setZipcode(rs.getString("zipcode"));
				dto.setAddress(rs.getString("address"));
				dto.setJob(rs.getString("job"));
			}
			
		} catch (Exception e) {
			System.out.println("getData err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return dto;
	}
	
	//�쉶�썝�젙蹂� �닔�젙 - �닔�젙�븯湲�
	public boolean modifyData(MemberBean bean){
		boolean b = false;
		try {
			String sql = "update webshop_member set pass=?,name=?, mail=?, phone=?, zipcode=?, address=?, job=? where id=?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getPass());
			pstmt.setString(2, bean.getName());
			pstmt.setString(3, bean.getMail());
			pstmt.setString(4, bean.getPhone());
			pstmt.setString(5, bean.getZipcode());
			pstmt.setString(6, bean.getAddress());
			pstmt.setString(7, bean.getJob());
			pstmt.setString(8, bean.getId());
			if(pstmt.executeUpdate()>0) b=true;
		} catch (Exception e) {
			System.out.println("modifyData err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return b;
	}
	
	//�쉶�썝 �깉�눜 - 鍮꾨�踰덊샇 �솗�씤
	public boolean deleteConfirm(String id, String passwd){
		boolean b = false;
		try {
			String sql = "select * from webshop_member where id = ? and pass = ?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, passwd);
			rs = pstmt.executeQuery();
			if(rs.next()) b = true;
			
		} catch (Exception e) {
			System.out.println("deleteConfirm err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return b;
	}
	
	//�쉶�썝 �깉�눜 - �깉�눜�븯湲�
	public boolean deleteData(String id){
		boolean b = false;
		try {
			String sql = "delete from webshop_member where id = ?";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			int re = pstmt.executeUpdate();
			if(re>0) b = true;
			
		} catch (Exception e) {
			System.out.println("deleteData err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return b;
	}
	
	/********************** 愿�由ъ옄 **********************/
	//愿�由ъ옄 濡쒓렇�씤
	public boolean admin_login(String admin_id,String admin_pass){
		boolean b = false;
		try {
			String sql = "select * from admin where admin_id = ? and admin_pass = ?";  //DB�뿉 愿�由ъ옄 怨꾩젙�쓣 留뚮뱾�뼱�몺 
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, admin_id);
			pstmt.setString(2, admin_pass);
			rs = pstmt.executeQuery();
			b=rs.next();
		} catch (Exception e) {
			System.out.println("admin_login err : " + e);
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		
		return b;
	}
	
	//愿�由ъ옄 - �쉶�썝紐⑸줉 �쟾泥� 異쒕젰
	public ArrayList<MemberDto> getMemberAll(){
		ArrayList<MemberDto> list = new ArrayList<MemberDto>();
		try {
			String sql = "select * from webshop_member";
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				MemberDto dto =  new MemberDto();
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setMail(rs.getString("mail"));
				dto.setPhone(rs.getString("phone"));
				list.add(dto);
			}
			
			
		} catch (Exception e) {
			System.out.println("getMemberAll err : ");
		} finally {
			try {
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return list;
	}

}
