

/*************************  guest/login.jsp *************************/


function funcLogin() {
	if (loginForm.id.value === "") {
		alert("아이디 입력");
		loginForm.id.focus();
	} else if (loginForm.passwd.value === "") {
		alert("비밀번호 입력");
		loginForm.passwd.focus();
	} else {
		loginForm.action = "login_action.jsp";
		loginForm.method = "post";
		loginForm.submit();
	}
}

function funcHome() {
	location.href = "login.jsp";
}

/******************  admin/membermanager.jsp ******************/

//관리자 회원정보보기
function admin_modify_member(id){
	document.modifyFrm.id.value=id;
	document.modifyFrm.submit();
}

