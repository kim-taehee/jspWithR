
 <%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="EUC-KR"%>

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

<h3>파일 업로드 폼</h3>
<center>

    <form action="barUpload.jsp"  method="post" enctype="Multipart/form-data">
        파일명1 : <input type="file" name="fileName1" /><br/>
        <input type="submit" value="전송" />  
        <input type="reset" value="취소" />

    </form>

    <form action="ecuUpload.jsp"  method="post" enctype="Multipart/form-data">
        파일명2 : <input type="file" name="fileName2" /><br/>
        <input type="submit" value="전송" />  
        <input type="reset" value="취소" />

    </form>


</center>

</html>

