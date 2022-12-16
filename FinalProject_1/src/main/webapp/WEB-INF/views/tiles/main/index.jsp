<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/index.css?after">
<style type="text/css">
	
</style>

<script type="text/javascript">
 	//캘린더
	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');
		var calendar = new FullCalendar.Calendar(calendarEl, { 
		  headerToolbar: {
		    left: 'prev,next today', 
		    center: 'title',
		    right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
		  },
		  contentHeight: 350,
		  locale: 'ko', 
		  navLinks: true, // can click day/week names to navigate views
		  businessHours: true, // display business hours
		  editable: true,
		  selectable: true,
		  select: function(arg) {
		      var title = prompt('일정 추가','입력해주세요..');
		      if (title) { 
		          calendar.addEvent({ 
		              title: title,
		              start: arg.start,
		              end: arg.end,
		              allDay: arg.allDay
		          })
		      }
		      calendar.unselect()
		  },
		  eventClick: function(arg) { 
		      if (confirm('일정을 삭제하시겠습니까?')) {
		          arg.event.remove()
		      }
		  }
		
		
		});
		
		calendar.render();

	});//end of calendar

	/*
	$(document).ready(function(){
		loopshowNowTime();
		
		//내피드 글씨 검정색으로 바꾸기
		$("#main").css("color","#4d4f53");
		$(".boardList_iscurrent").css("color","#4d4f53");
		
		// 근무 fadeToggle 이벤트
		$("#workStatusListBox").fadeOut(100);
		$("#workStatusChange").fadeOut(100);
		
		$("#workStatus").click(function(){
			$("#workStatusListBox").fadeToggle(100); 
		});
		
		$("#changeWorkingStatus").click(function(){
			$("#workStatusChange").fadeToggle(100);
			$("#workStatusChange").mouseleave(function(){
				$(this).fadeOut(200);
			});
		});
		
		
		
		
		
	});//end of ready

	// 외부 클릭시 닫기
	$(document).mouseup(function(e){
		if( !(($("#workStatusListBox").has(e.target).length||$("#workStatusChange").has(e.target).length)) ){
			$("#workStatusListBox").fadeOut(100);
			$("#workStatusChange").fadeOut(100);
		}//end of mouseup
	});//end of mouseup

function showNowTime() {
	var now = new Date();
	var month = now.getMonth() + 1;
	var date = now.getDate();

	var hour = "";
	if (now.getHours() < 10) {
		hour = "0" + now.getHours();
	} else {
		hour = now.getHours();
	}

	var minute = "";
	if (now.getMinutes() < 10) {
		minute = "0" + now.getMinutes();
	} else {
		minute = now.getMinutes();
	}

	var second = "";
	if (now.getSeconds() < 10) {
		second = "0" + now.getSeconds();
	} else {
		second = now.getSeconds();
	}

	var strNow = now.getFullYear() + "년" + month + "월" + date + "일";
	strNow += " " + hour + ":" + minute + ":" + second;

	$("#date").html(strNow);
}// end of function showNowTime() -----------------------------

function loopshowNowTime() {
	showNowTime();

	var timejugi = 1000; // 시간을 1초 마다 자동 갱신하려고.

	setTimeout(function() {
		loopshowNowTime();
	}, timejugi);

}// end of loopshowNowTime() --------------------------
 */


</script>

<div style="margin-left: 0.5%; width: 60%; float:left; height: 640px;">
	<div class="mainheader">
		<div style="width: 100%;">
			<span>내근무</span>
			<span style="float:right;"><button type="button" class="headerMore">더보기</button></span>
		</div>
	</div>
	<div class="Ad-c" style="height: 154px;">
		<div class="todayAd" style="width: 100%; padding-left: 5%; ">
			<div><div class="main-iconindex" style="background-color: rgba(66, 133, 244, 0.2);"><img src="https://emojipedia-us.s3.amazonaws.com/source/microsoft-teams/337/alarm-clock_23f0.png" width="25px"style="margin: auto;"></div></div>
			<div style="margin-left: 15px;">
				<div class="ad-sumheader">오늘의 근무</div>
				<table class="Adtable">
					<tr>
						<td>출근</td>
						<c:if test="${not empty requestScope.starttime}">
							<td>${requestScope.starttime}</td>
						</c:if>
						<c:if test="${empty requestScope.starttime}">
							<td style="color:#D2D6D9;">미지정</td>
						</c:if>
						<td style="padding-left: 10px;">퇴근</td>
						<c:if test="${not empty requestScope.endtime}">
							<td>${requestScope.endtime}</td>
						</c:if>
						<c:if test="${empty requestScope.endtime}">
							<td style="color:#D2D6D9;">미지정</td>
						</c:if>
						<c:if test="${not emptyrequestScope.todayWorkingTime}">
						<td><div class="AdtimeSub">${requestScope.todayWorkingTime}</div></td>
						</c:if>
					</tr>
				</table>
			</div>
			<div><i class="fas fa-angle-right" aria-hidden="true"></i></div>
		</div>
		<hr style="border:none; height:1px; background-color: rgba(220,220,220); margin: 0;"/>
		<div class="weekAd todayAd" style="padding-left: 5%; width: 100%;">
			<div><div class="main-iconindex" style="background-color: #FFFADF;"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/325/briefcase_1f4bc.png" width="20px"style="margin: auto; left:11px;"></div></div>
			<div style="margin-left: 15px;">
				<div class="ad-sumheader">이번주 근무</div>
				<table class="Adtable">
					<tr>
						<td>정규</td>
						<c:if test="${requestScope.regularWt != '0'}">
							<td>${requestScope.regularWt}</td>
						</c:if>
						<c:if test="${requestScope.regularWt == '0'}">
							<td style="color:#D2D6D9;">미지정</td>
						</c:if>
						<td style="padding-left: 10px;">초과</td>
						<c:if test="${requestScope.overWt != '0'}">
							<td>${requestScope.overWt}</td>
						</c:if>
						<c:if test="${requestScope.overWt == '0'}">
							<td style="color:#D2D6D9;">미지정</td>
						</c:if>
						<c:if test="${not emptyrequestScope.weekWorkingTime}">
						<td><div class="AdtimeSub">${requestScope.weekWorkingTime}</div></td>
						</c:if>
					</tr>
				</table>
			</div>
			<div><i class="fas fa-angle-right" aria-hidden="true"></i></div>
		</div>
	</div>
	<div class="mainheader" style="clear:both; border-top: solid 1px rgba(240,240,240);">
		<div style="width: 100%;">
			<span>게시판</span>
			<span style="float:right;"><button type="button" class="headerMore">더보기</button></span>
		</div>
	</div>
	<div class="todayAd-c" style="height: 300px;">
		<div id="board">
			<nav id="boardList">
				<a class="boardList_iscurrent">공지사항</a>
				<a>자유게시판</a>
				<div class="boardList_underline"></div>
			</nav>
			<hr style="border: none; height:1px; background-color: rgba(210,210,210); margin:0;">
			<table width="100%" style="font-size: 11pt; width: 100%;" align="center">
				<tr class="boardTr">
					<td class="py-1 pl-2">
						<div>글제목</div>
						<span style="font-size:9pt; color:gray;">
							<span class="mr-4">날짜</span>
							<span>글쓴이·팀</span>
						</span>
					</td>
				</tr>
				<tr class="boardTr">
					<td class="py-1 pl-2">
						<div>글제목</div>
						<span style="font-size:9pt; color:gray;">
							<span class="mr-4">날짜</span>
							<span>글쓴이·팀</span>
						</span>
					</td>
				</tr>
				<tr class="boardTr">
					<td class="py-1 pl-2">
						<div>글제목</div>
						<span style="font-size:9pt; color:gray;">
							<span class="mr-4">날짜</span>
							<span>글쓴이·팀</span>
						</span>
					</td>
				</tr>
				<tr class="boardTr">
					<td class="py-1 pl-2">
						<div>글제목</div>
						<span style="font-size:9pt; color:gray;">
							<span class="mr-4">날짜</span>
							<span>글쓴이·팀</span>
						</span>
					</td>
				</tr>
				<tr class="boardTr">
					<td class="py-1 pl-2">
						<div>글제목</div>
						<span style="font-size:9pt; color:gray;">
							<span class="mr-4">날짜</span>
							<span>글쓴이·팀</span>
						</span>
					</td>
				</tr>
			</table>
			<hr style="background-color: rgba(240,240,240); margin:0;" class="HRhr"/>
			<div id="boardPagingArrow" align="center" style="color: #4d4f53; margin-top: 20px;">
				<span class="mr-5"><i class="fa-solid fa-angle-left" style="font-size:10pt;"></i></span>
				<span><i class="fa-solid fa-angle-right" style="font-size:10pt;"></i></span>
			</div>
		</div>
	</div>
</div>
<div style="width: 39.5%; float: right; border-left:solid 1px rgba(220,220,220); height: 640px;">
	<div class="mainheader">
		<div style="width: 100%;">
			<span>요청사항</span>
			<span style="float:right;"><button type="button" class="headerMore" style="margin-right: 60px;">더보기</button></span>
		</div>
	</div>
	<div class="board-c" style="height: 135px; color:#D2D6D9; font-size: 10pt; text-align:center; vertical-align: middle;">
		<c:if test="${empty requestScope.apList}">
			<div class="" style="padding-top:35px;">
				<div class="icon icon-file-text2" style="margin-bottom: 5px; font-size: 11pt;"></div>
				<div style="margin-bottom: 10px;">현재 요청사항이 없습니다.</div>
				<button type="button" id="goav">결재 보기</button>
			</div>
		</c:if>
		<c:if test="${not empty requestScope.apList}">
			<c:forEach var="ap" items="${requestScope.apList}">
				<div class="bg-light text-dark" style="width: 83%; border-radius: 5px; margin: 10px 25px;">
					<c:if test="${empty ap.profile_systemfilename}">
						<span class="pic sbpics">
							<span>${ap.name_kr}</span>
						</span>
					</c:if>
				   	<!-- <i class="fas fa-user-circle" style="color:#737373; font-size:33px; float: left; padding: 14px;"></i> -->
				   	<div class="card-body" style="height: 60px; display: table-cell; padding-left: 0; vertical-align: middle; clear: both; width: 1177px;">
				   		<div class="apContent">
					   		<span>승인 요청 - '${ap.title}'</span>
					   		<span>${ap.name_kr}・${ap.writeday}</span>
					   		<div>
						   		<button type="button" class="btn btn-sm button" id="return" style="background-color: white; border: solid 0.5px #e6e6e6; color: #595959; margin-right: 1px; font-weight:600; font-size: 10pt;">반려</button>
								<button type="button" class="btn btn-sm button" id="approval" style="background-color: #3385ff; color: white; font-weight:600; font-size: 10pt;">승인</button>
							</div>
						</div>
				   	</div>
				</div>
			</c:forEach>
		</c:if>		
		
		
	</div>
	<hr style="border:none; height:1px; background-color: rgba(220,220,220);"/>
	<div class="schedule-c" style="margin: 0 20px;">
		<div id="calendar" style=" margin: 30px 0 20px 0; padding: 0 30px; width: 512px; font-size: 9pt; color: #4d4f53; position:relative; right: 22px;">
		<div id="calendar_header" style="width:100%;">
			<i class="icon-chevron-left"></i>
			<h1></h1><i class="icon-chevron-right"></i>
		</div>
		<div id="calendar_weekdays" style="width:100%;"></div>
		<div id="calendar_content" style="width:100%;"></div>
	</div>
	</div>
	

</div>
