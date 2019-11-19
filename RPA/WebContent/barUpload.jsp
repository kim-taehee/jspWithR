<%@page import="jsptest.barcodeExtract"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<%
 
    // request.getRealPath("상대경로") 를 통해 파일을 저장할 절대 경로를 구해온다.
    // 운영체제 및 프로젝트가 위치할 환경에 따라 경로가 다르기 때문에 아래처럼 구해오는게 좋음
    String uploadPath = request.getRealPath("/Upload");
	// out.println("절대경로 : " + uploadPath + "<br/>");
    int maxSize = 1024 * 1024 * 10; // 한번에 올릴 수 있는 파일 용량 : 10M로 제한

    String fileName1 = ""; // 중복처리된 이름
    String originalName1 = ""; // 중복 처리전 실제 원본 이름
    long fileSize = 0; // 파일 사이즈
    String fileType = ""; // 파일 타입
    MultipartRequest multi = null;


    try{
        // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
        multi = new MultipartRequest(request,uploadPath,maxSize,"utf-8",new DefaultFileRenamePolicy());
        // 전송한 전체 파일이름들을 가져옴
        // 어떠한 이름을 올려도 기준파일로 변경
        Enumeration files = multi.getFileNames();
        String fname = (String)files.nextElement();
        String fileName = multi.getFilesystemName(fname);
        String newFileName ="";
        if(fileName != null){
           File upfile1 = new File(uploadPath+"/"+fileName); //--'/'를빼고 작업했다 .그래서 경로가 제대로 나오지 않음
           File upfile2 = new File(uploadPath+"/"+"barcode.pdf");
           if(upfile1.renameTo(upfile2)){
             //  out.print("이름변경성공");
            }else{
            //   out.print("이름변경실패");
           }
         //out.print("업로드 된 파일명="+uploadPath+"/"+upfile2.getName());
         newFileName = upfile2.getName();

        }

        
    }catch(Exception e){
        e.printStackTrace();
    }
        System.out.println(fileName1);
    
     barcodeExtract barcode = new barcodeExtract();
     barcode.Run();
        
    
%>




<%//여기에  %>

 
<!-- 
    a태그로 클릭시 파일체크하는 jsp페이지로 이동하도록 함
    javascript를 이용해서 onclick시 폼태그를 잡아와 submit()을 호출해 폼태그를 전송


<a href="#" onclick="javascript:document.fileCheckFormName.submit()">업로드 파일 확인하기 :<%=fileName1 %></a>
 -->