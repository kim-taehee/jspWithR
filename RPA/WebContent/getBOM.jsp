<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.DataOutputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.net.ssl.HttpsURLConnection" %>
<%@ page import="java.nio.file.Files"%>
<%@ page import="java.nio.file.Paths"%>
<%@ page import="java.nio.charset.Charset"%>
<%@ page import="java.io.IOException"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.*"%>

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

<%
// partNo 받아와서 정보 저장
request.setCharacterEncoding("UTF-8"); //받아올 데이터의 인코딩
String partNo = request.getParameter("partNo");
System.out.println("partNo:"+ partNo);

String fName1 = "D:\\RPA결과\\partNo.txt";
PrintWriter pw1=null;
try{
	pw1 = new PrintWriter(fName1);
	pw1.println(partNo);
	//out.println("저장완료");
}catch(IOException e){
	//out.println("저장실패");
}finally{
	try{
		pw1.close();
	}catch(Exception e){
		
	}
}
////////////////////////


/// Json API connect
String targetUrl = "http://10.110.11.71/Windchill/extcore/mando/company/rpa/fa_rpa_getpartlist.jsp?partinfo=K02$"+partNo;
System.out.println("targetUrl:"+targetUrl);

URL url = new URL(targetUrl);
HttpURLConnection con = (HttpURLConnection) url.openConnection();

con.setRequestMethod("GET"); // optional default is GET
con.setRequestProperty("User-Agent", "Mozilla/5.0"); // add request header
int responseCode = con.getResponseCode();
System.out.print("responseCode:"+responseCode);

BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

String resp =in.readLine();
in.close();


//// 필요정보 추출
JSONParser parser = new JSONParser();
JSONArray array = (JSONArray) parser.parse(resp);
System.out.println(resp);

String fName = "D:\\RPA결과\\bom.csv";
PrintWriter pw=null;
try{
	pw = new PrintWriter(fName);
	for(int i=0; i<array.size(); i++){
	    //배열 안에 있는것도 JSON형식 이기 때문에 JSON Object 로 추출
	    JSONObject bookObject = (JSONObject) array.get(i);
	    //JSON name으로 추출
		// to table
		pw.print(bookObject.get("partname")+",");
		pw.println(bookObject.get("partno"));
	}
	System.out.println("저장완료");
}catch(IOException e){
	System.out.println("저장실패");
}finally{
	try{
		pw.close();
	}catch(Exception e){
		
	}
}
 

%>


</body>

</html>


