<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>    
<!DOCTYPE html>
<html>
<head>   

<title>Thumbs up</title>
<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script src="https://kit.fontawesome.com/48a76cd849.js" crossorigin="anonymous"></script>
<!-- 폰트 목록 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%=ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

<!-- jQueryUI CSS 및 JS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
<!-- 혜린style.css -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/message_memberList.css?after">

<!-- pretendard-font -->
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.6/dist/web/static/pretendard.css" />

<link rel="stylesheet" href="<%= request.getContextPath()%>/resources/fonts/icomoon/style.css">

<style type="text/css">
	
</style>

<script type="text/javascript">
	//체크박스 개수
	var total = $("input[name='memberChx']").length;
	
	$(document).ready(function(){
		
		// 전체개수 값
		const allCnt = $("input:checkbox[name='memberChx']").length;  // 체크여부 상관없는 모든 체크박스개수
		document.getElementById("memberCnt").textContent = allCnt;
		
		
		// 체크박스 전체선택 기능 및 체크박스 선택시 메뉴 변경
		$("#memberAll").change(function(){
			if($("#memberAll").is(":checked")){
				var total = $("input[name='memberChx']").length;
				$("input[name='memberChx']").prop("checked",true);
				show_checkmenu();
				$("#check_ctn").text(total);
			} else {
				$("input[name='memberChx']").prop("checked",false);
				show_noncheckmenu();
			}
		});
		
		$("input[name='memberChx']").change(function() {
			//체크박스 선택
			check_one(); 
		});
		
		// 프로필 클릭시 구성원 선택
		$(".mem-tr").click(function(e){
			//체크박스 선택시 함수 종료
			if( $(e.target).is('input:checkbox') ) return;
			var memcheck = $(this).find("td:first-child > input");
			if(memcheck.prop("checked"))
				memcheck.prop("checked",false);
			else
				memcheck.prop("checked",true);
			//체크박스 선택
			check_one();
		});
		
		// 취소 버튼 누를시 선택 모두 해제하기
		$("#ml-cancel").click(function(){
			$("input[name='memberChx']").prop("checked",false);
			$("#memberAll").prop("checked",false);
			show_noncheckmenu();
		});
		
		
		// 메뉴창 커질때 컨텐트 내용물 사이즈 줄어들게 하기
		$("input#burger-check").change(function(){
		    if($("#burger-check").is(":checked")){
		        $(".big").css({'width':'55.2%','position':'relative','top':'18px'});
		        $(".big table").css({"width":"100%","top":""});
		        $(".menucontent").css({'visibility':'visible'});
		    }else{
		        $(".big").css({'width':'100%','position':'','top':''});
		        $(".big table").css("width","100%");
		        $(".menucontent").css({'visibility':'hidden'});
		    }
		});  
		
		// 모든 조직 펼치기
		$(".unfold").click(function(){  // 조직도 확대 아이콘 클릭시
			$(".summary").click();      // 모든 조직의 summary 클릭
		});
		
			
	});// end of$(document).ready(function(){})--------------------------
	   
	///////////////////////////////////////////////////////////////////////////////////////////////////////    
	// Function declaration
	//체크시 나타나는 메뉴
	function show_checkmenu(){
		$(".ml-noncheckmenu").hide();
		$(".ml-checkmenu").fadeIn("fast");
	}//end of show_checkmenu
	
	// 체크안되었을때 나타나는 메뉴
	function show_noncheckmenu(){
		$(".ml-checkmenu").hide();
		$(".ml-noncheckmenu").fadeIn("fast");
	}//end of show_noncheckmenu
	
	//체크박스 하나 체크 이벤트
	function check_one(){
		var checked = $("input[name='memberChx']:checked").length;

		if(checked<=0) {
			$("#memberAll").prop("checked", false);
			show_noncheckmenu();
		}
		else if(total != checked){
			$("#memberAll").prop("checked", true); 
			show_checkmenu();
			$("#check_ctn").text(checked);
		}
		
	}//end of check_one
	
</script>
</head>
<body>

<div>
	<div>
		<form action="#" class="booking-form" style="float: right; margin-right: 20px;">
			<div class="row" style="padding-top: 11px;">
				<%-- 검색 --%>
				<div class=" mr-2">
					<div class="form-group">
						<div class="form-field">
							<select name="searchCondition" id="searchCondition" style="font-size: 9pt; padding:6.7px 12px;">
								<option value="">이름</option>
								<option value="">소속</option>
								<option value="">직무</option>
								<option value="">직위</option>
							</select>
						</div>
					</div>
				</div>
				<div>
					<div class="form-group">
						<div class="form-field" style="padding-left:5px; margin-right: -9px;">
							<input type="text" class="form-control" placeholder="검색" style="width:90%; font-size: 9pt; padding:6px 12px;">
						</div>
					</div>
				</div>
				<div class="align-items-end mt-1 mr-4">
					<div class="form-group seachIcon" style="font-size: 10pt; margin-bottom:0;">
						<a href="#" class="btn icon icon-search" style="color:#76787a; background-color: white; font-size: 0.8rem; padding: 0.375rem; position: absolute; right: 14%;"></a>
					</div>
				</div>
				<div>
					<span class="arrayIcon">
						<span><ion-icon name="swap-vertical-outline" style="position: absolute; left: 7px; bottom:7px; font-size: 12pt;"></ion-icon></span>
		            </span>
				</div>
				<div>
					<span class="groupIcon">
						<input class="burger-check" type="checkbox" id="burger-check" />
						<label class="burger-icon" for="burger-check"><span class="burger-sticks"></span></label>
						<div class="menu">
							<div class="menucontent" style="width: 340px; visibility: hidden; padding: 27px 0px 10px 38px;">
								<div style="font-size: 12pt; font-weight: bold; color: #4C4E54; padding-bottom: 27px;">
									<span style="padding-right: 190px;">조직도</span>
									<span><i class="fas fa-expand-alt unfold"></i></span>
									<span class="unfoldAlert" style="display: none;">모든 조직 펼치기</span> <%-- 호버 이벤트시 jQuery 효과주기 --%>
								</div>
								<details>
									<summary class="summary">IT</summary>
								   	<ul>
								      <li><a href="#" class="orgmenu">개발1팀</a><span id="cntbadge" ><span id="newCnt">1</span></span></li>
								      <li><a href="#" class="orgmenu">개발2팀</a></li>
								      <li><a href="#" class="orgmenu">기술지원팀1팀</a></li>
								    </ul>
								</details>
								<details>
									<summary class="summary">기획</summary>
								   	<ul>
								      <li><a href="#" class="orgmenu">기획1팀</a><span id="cntbadge" ><span id="newCnt">1</span></span></li>
								      <li><a href="#" class="orgmenu">기획2팀</a></li>
								    </ul>
								</details>
							</div>
						</div>
		            </span>
				</div>
			</div>
		</form>
	
	<%-- 전체 구성원 --%>
	<div class="ml-top-left">
		<input type="checkbox" id="memberAll" />
		<span class="ml-noncheckmenu" style="display: inline-block; height: 30px; position:relative; top:3px;">
			<label for="memberAll"><span>전체 구성원 &nbsp;<span style="color:#4285f4;" id="memberCnt"></span>명</span></label>
		</span>
		<span class="ml-checkmenu" style="display: none;">
			<label for="memberAll">
				<span id="check_ctn"></span>명 선택
			</label>
			<button type="button" id="ml-save" class="gradientbtn" style="font-size: 9pt;">저장</button>		
			<button type="button" id="ml-cancel">취소</button>
		</span>
	</div>
	<div class="big" style="height: 400px; overflow-y: auto; width: 100%;">
		<table class="table custom-table big" style="float: left;">
			<colgroup>
				<col width="5px" />
				<col width="650px" />
				<col width="220px" />
			</colgroup>
			<c:forEach var="i" begin="1" end="10">
				<tr class="mem-tr">
					<td><input type="checkbox" name="memberChx" id="pnum${status.index}" value=""/></td>   
					<td>
						<div class="profile" href="#" style="padding: 1px;">
							<span class="pic"><span>지은</span></span>
							<span class="my">
								<span class="name" style="font-size: 10.8pt;">김지은</span><br>
								<span class="role" style="font-size: 9pt;">개발자</span>
							</span>
						</div>
					</td> 
					<td>
						<span class="positionIcon">
							<span>IT 개발1팀&nbsp;|&nbsp;대리</span>
						</span>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</div>
</div>
</body>
</html>
