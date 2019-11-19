//REST Server �����ؼ� JSON ������ �޾ƿ��� �Լ�
function AjaxTest(){
	$(document).ready(function(){
		$.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "getBOM.jsp",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.]
	            data: {},
	            error : function(request,status,error){
	                alert("통신실패!!!!");
	                alert("code = "+ request.status + " message = " + request.responseText + " error = " + error);
	            },
	            success : function(data){
	                //$("#showFData").html(Parse_data); //div에 받아온 값을 넣는다.
	                alert("통신 데이터 값 : " + data);
	                var obj = JSON.parse(data);
	                var partno = obj.partno;
	                var partname = obj.partname;
	                Json2Table(Parse_data)
	            },
	            complete : function(request,status,error){
	            	alert("code = "+ request.status + " message = " + request.responseText + " error = " + error);
	            }
	        });
	    });
}

//json을 html table로 변환해줌
function Json2Table(obj) {
    var txt = "";
    var txt2 = "";
    var masterlist = ["BH484", "BG690", "BH611", "BH660", "BH680", "BH700", "BH730", "BH810", "BH880", "BH900", "BE600"];

    txt += "<table><tr><th>PARTNO</th><th>PARTNAME</th></tr>";
    txt2 += "<table><tr><th>PARTNO</th><th>PARTNAME</th></tr>";
    for (x in obj) {
        txt += "<tr><td>" + obj[x].partno + "</td><td>" + obj[x].partname + "</td></tr>";
        for (y in masterlist) {
            if (obj[x].partno.slice(0, 5) == masterlist[y]) {
                if (obj[x].partno.slice(0, 5) == masterlist[10]) {
                    document.getElementById("test").innerHTML = obj[x].partno;
                } else {
                    txt2 += "<tr><td>" + obj[x].partno + "</td><td>" + obj[x].partname + "</td></tr>";
                }
            }
        }
    }
    txt += "</table>"
    txt2 += "</table>"
    //document.getElementById("showData").innerHTML = txt;
    document.getElementById("showFData").innerHTML = txt2;
}

function loadDoc() {
    var x = document.getElementById("pnSearch").value;
    var url = "getBOM.jsp?partinfo=K02$" + x;
    
    xhttp = new XMLHttpRequest();
    xhttp.open("GET", url, true);
    xhttp.onreadystatechange = function () {
        document.getElementById("test").innerHTML = this.readyState;
        document.getElementById("test2").innerHTML = this.status;
        document.getElementById("test3").innerHTML = this.statusText;
        if (this.readyState == 4 && this.status == 200) {
            var partObj = JSON.parse(this.responseText);
            alert(this.responseText);
            //document.getElementById("test").innerHTML = x;
            Json2Table(partObj)
            JsonTransfer(partObj)
        }
    };
    xhttp.send();
}

function JsonTransfer(obj) {
    alert('JsonTransfer 진입!')
    var aJsonArray = new Array();
    var masterlist = ["BH484", "BG690", "BH611", "BH660", "BH680", "BH700", "BH730", "BH810", "BH880", "BH900", "BE600"];
    for (x in obj) {
        for (y in masterlist) {
            if (obj[x].partno.slice(0, 5) == masterlist[y]) {
                var aJson = new Object();
                aJson.partno = obj[x].partno;
                aJson.partname = obj[x].partname;
                aJsonArray.push(aJson);
            }
        }
    }
    var sJson = JSON.stringify(aJsonArray);
    document.getElementById("json").innerHTML = sJson;
    
    $(document).ready(function () {

        $.ajax({
            type: "POST", //전송방식을 지정한다 (POST,GET)
            url: "NewFile.jsp",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
            dataType: "json",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
            data: {json: sJson},
            error: function (request, status, error) {
                alert("통신실패!!!!");
                alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
            },
            success: function (data) {
                alert("통신 데이터 값 : " + data);
            },
            complete: function (request, status, error) {
                alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
            }
        });
    });

}


function json2jsp(){}
//json�� html table�� ��ȯ����
function Json2Table(obj) {
    var txt = "";
    var txt2 = "";
    var masterlist = ["BH484", "BG690", "BH611", "BH660", "BH680", "BH700", "BH730", "BH810", "BH880", "BH900", "BE600"];

    txt += "<table><tr><th>PARTNO</th><th>PARTNAME</th></tr>";
    txt2 += "<table><tr><th>PARTNO</th><th>PARTNAME</th></tr>";
    for (x in obj) {
        txt += "<tr><td>" + obj[x].partno + "</td><td>" + obj[x].partname + "</td></tr>";
        for (y in masterlist) {
            if (obj[x].partno.slice(0, 5) == masterlist[y]) {
            	if(obj[x].partno.slice(0, 5) == masterlist[10]){
            		document.getElementById("ecuId").innerHTML = obj[x].partno;
            	}
                txt2 += "<tr><td>" + obj[x].partno + "</td><td>" + obj[x].partname + "</td></tr>";
            }
        }
    }
    txt += "</table>"
    txt2 += "</table>"
    //document.getElementById("showData").innerHTML = txt;
    document.getElementById("showFData").innerHTML = txt2;
}

//table�� excel�� ���������
function ReportToExcelConverter() {
    $("#showFData").table2excel({
        exclude: ".noExl",
        name: "Excel Document Name",
        filename: $("#pnSearch").val() + '.xls', //Ȯ���ڸ� ���⼭ �ٿ�����Ѵ�.
        fileext: ".xls",
        exclude_img: true,
        exclude_links: true,
        exclude_inputs: true
    });
};

//type='file'�� ���õ� ������ ��ü ��ΰ� �ƴ� ���ϸ� ���̵��� �������
function ChangeText(oFileInput, sTargetID, sTargetID2) {
    var fullpath = oFileInput.value;
    var filepath = fullpath.split("\\").pop();
    document.getElementById(sTargetID).value = filepath;
    document.getElementById(sTargetID2).innerHTML = fullpath;
}

//������ �̵�������
function move(sTargetID) {
    var myObject;
    myObject = new ActiveXObject("Scripting.FileSystemObject");
    var fullpath = document.getElementById(sTargetID).innerText;
    var filepath = fullpath.split("\\").pop();
    myObject.MoveFile(fullpath, "C:\\Users\\mando\\source\\repos\\Excute\\" + filepath);
}

//�������� ���̺�� ������
function excel2table() {
    $('#input-excel').change(function (e) {
        var reader = new FileReader();

        reader.readAsArrayBuffer(e.target.files[0]);

        reader.onload = function (e) {
            var data = new Uint8Array(reader.result);
            var wb = XLSX.read(data, { type: 'array' });

            var htmlstr = XLSX.write(wb, { sheet: "Sheet1", type: 'binary', bookType: 'html' });
            $('#showFData')[0].innerHTML += htmlstr;
        }
    })
}

//���� �����͸� table�� ������
function GetData(dir,id) {
    txt = "<table><tr><th>PARTNO</th><th>PARTNAME</th></tr>"; //��� ����
    var row = 10;
    var column = 3;
    var data = '';
    var excel = new ActiveXObject("Excel.Application");
    var excel_file = excel.Workbooks.Open(dir);
    var excel_sheet = excel.Worksheets("Sheet1");
    for (i = 2; i < row; i++) {
        txt += "<tr>";
        for (j = 1; j < column; j++) {
            data = excel_sheet.Cells(i, j).Value;
            txt += "<td>" + data + "</td>";
        }
        txt += "</tr>";
    }
    txt += "</table>";
    document.getElementById(id).innerHTML = txt;
}