<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<% String ctxPath = request.getContextPath(); %>
<style>
	.toastui-editor-defaultUI-toolbar{background-color: white;}
	.btn:hover{color: white;}
	#mw-to:hover{cursor:pointer;}
</style>
<script>
$(document).ready(function(){
	
	// 답장번호(reno)가 있을 때 값 미리 넣어주기
	const mw_to = "${requestScope.mw_to}";
	const mw_resubject = "${requestScope.mw_resubject}";
	if(mw_to != null ){
		$("#mw-to").val(mw_to);
		$("#mw-subject").val("RE: "+mw_resubject);
	}
	
	//받는사람 입력시 주소록 모달 뜨기
	$("#mw-to").click(function(){
		$("#mw-address").trigger("click");
	});
	
	
	<%-- 텍스트 에디터 시작 --%>
	const editor = new toastui.Editor({
	    el: document.querySelector("#editor"),
	    height: "390px",
	    initialEditType: "wysiwyg",
	    hooks: {
	      addImageBlobHook: function (blob, callback) {
	        const formData = new FormData();
	        formData.append("image", blob);
	        const imageURL = imageUpload(formData);
	        // console.log(imageURL);
	        callback(imageURL, "image");
	      },
	    },
	    language: 'ko-KR'
	 });
	<%-- 텍스트 에디터 끝 --%>
});//end of ready

// function declaration
// 보내기 버튼
function goSend(){ 
	
};// end of goSend


// 모달창에서 저장한 값 가져오기
function setEmp(m_empno, m_empname){
	$("#empno").val(m_empno);
	$("#empname").val(m_empname);
	
	$("#mw-address-modal").modal('hide');
}
	

</script>    
    
<div class="mw-container">
	<div class="mw-top">
		<div style="float:left;">
			<div class="mw-top-1">
				<span class="header-nonsub" style="padding:1.4em 0 !important;" onclick="javascript:location.href='<%= ctxPath%>/message.up'"><i class="fa-solid fa-chevron-left" style="font-size: 15pt;"></i></span>
				<span class="header-nonsub" style="padding:1.4em 0 !important;">메시지 보내기</span>
			</div>
		</div>		
		<div class="mw-top-right" style="float:right; padding: 2.65em 0; margin-right: 10px;">
			<span>
				<button type="button" id="mw-book" class="btn" data-bs-toggle="modal" data-bs-target="#mw-book-modal" data-bs-dismiss="modal">예약</button>
			</span>
			<span>
				<button type="button" id="mw-send" class="gradientbtn btn" onclick="goSend();">
					<span><i class="fa-regular fa-paper-plane"></i></span>
					<span>보내기</span>
				</button> <!-- 보낸메일함의 보낸 메일으로 이동. -->
			</span>		
		</div>
	</div>
	<hr class="HRhr" style="clear:both;"/>
	<div class="mw-bottom">
		<table class="mw-table" style="width: 100%;">
			<tr>
				<td>받는 사람</td>
				<td width="86.4%"><input id="mw-to" type="text" placeholder="받는사람" readonly/></td> <!-- 답장하기의 경우 자동으로 입력되게 --> <!-- 클릭시 자동으로 밑에 최근 보낸사람? 뜨게 -->
				<td><button id="mw-address" class="btn" type="button" data-bs-toggle="modal" data-bs-target="#mw-address-modal" data-bs-dismiss="modal">주소록</button></td>
			</tr>
			<tr>
				<td>제목</td>
				<td colspan="2"><input id="mw-subject" type="text" placeholder="제목을 입력하세요"/></td> <!-- 답장하기의 경우 RE: 하고 제목 가져오기. 총 20자까지 -->
			</tr>
			<tr>
				<td>파일첨부</td>
				<td colspan="2">
					<div class="input-group" style="font-size: 11pt !important;">
						<input type="file" class="form-control" id="inputGroupFile02" style="border: solid 1px rgba(0,0,0,0.1); font-size: 11pt; height: 33px; position:relative; top:3px;">
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="3"><div id="editor" style="font-weight: 500;"></div></td>
			</tr>
		</table>
	</div>

	<%-- **** 예약버튼  Modal **** --%> <!-- 이거 기능하다가 벅차면 빼자요 -->
	<div class="modal fade" id="mw-book-modal" aria-hidden="true" aria-labelledby="mw-address-label" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="exampleModalToggleLabel" style="margin-left: 15px; font-weight: 800;">발송 예약</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
			  		<div id="mwa-container">
						<iframe id="mwa" style="border: none; width: 100%; height: 400px;" src="<%= request.getContextPath()%>/message/book.up"></iframe>
					</div>
			  	</div>
			</div>
		</div>
	</div>

	<%-- **** 주소록 Modal **** --%>
	<div class="modal fade" id="mw-address-modal" aria-hidden="true" aria-labelledby="mw-address-label" tabindex="-1">
		<div class="modal-dialog modal-lg modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="exampleModalToggleLabel" style="margin-left: 15px; font-weight: 800;">주소록</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
			  		<div id="mwa-container">
						<iframe id="mwa" style="border: none; width: 100%; height: 500px;" src="<%= request.getContextPath()%>/message/memberList.up"></iframe>
					</div>
			  	</div>
			</div>
		</div>
	</div>
	
	<form>
		<input id="empno" type="text" value="">
		<input id="empname" type="text" value="">
	</form>
	


</div>