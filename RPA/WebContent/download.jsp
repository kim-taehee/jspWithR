<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.IOException"  %>
<%@ page import="java.io.InputStream"  %>
<%@ page import="java.io.BufferedReader"  %>
<%@ page import="java.io.BufferedWriter"  %>
<%@ page import="java.io.OutputStreamWriter"  %>
<%@ page import="java.io.InputStreamReader"  %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%


	String[] commands = new String[] {
		"py C:\\cropJava\\RPAmerge.py"
	};

	try {
		ProcessBuilder b = new ProcessBuilder("cmd");
		b.redirectErrorStream(true);
		Process p = b.start();

		BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));

		for (String cmd : commands) {
			writer.write(cmd + "\n");
			writer.flush();
		}

		writer.write("exit" + "\n");
		writer.flush();

		BufferedReader std = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String outputLine = "";
		String outputMessage = "";
		while ((outputLine = std.readLine()) != null) {
			outputMessage += outputLine + "\r\n";
		}

		p.waitFor();
		
		System.out.println(outputMessage);
	} 
	catch (Exception e) { e.printStackTrace(); }
	
	
	
	
	
    request.setCharacterEncoding("UTF-8");
    // 파일 업로드된 경로
    String savePath =  "D:/RPAdownload";
    // 서버에 실제 저장된 파일명
    String filename = "result.csv" ;  // make fname
    // 실제 내보낼 파일명
    String orgfilename = "result.csv" ;  // end of download, delete 

    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String client = "";

    try{
        // 파일을 읽어 스트림에 담기
        try{
            file = new File(savePath, filename);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){
            skip = true;
        }

      client = request.getHeader("User-Agent");
        // 파일 다운로드 헤더 지정
        response.reset() ;
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");

        if(!skip){
            // IE
            if(client.indexOf("MSIE") != -1){
                response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
            }else{
                // 한글 파일명 처리
                orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");
             	response.setHeader("Content-Disposition", "attachment; filename=\"" + orgfilename + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            }  
            response.setHeader ("Content-Length", ""+file.length() );
            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()];
            int leng = 0;        

            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }


        }else{
            response.setContentType("text/html;charset=UTF-8");
            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
        }

        in.close();
        os.close();
        
        if( file.exists() ){
        	if(file.delete()){ 
        		System.out.println("파일삭제 성공"); 
        	}else{ 
        		System.out.println("파일삭제 실패"); 
        	}
        }else{ 
        	System.out.println("파일이 존재하지 않습니다."); 
        }

    }catch(Exception e){
      e.printStackTrace();
    }

%>
