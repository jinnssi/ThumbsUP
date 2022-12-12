<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="attendance_header.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style type="text/css">
	.atnotice {
	    font-size: 8.5pt;
	    font-weight: 500;
	    margin-bottom: 38px;
	}
	
	.worktype {
		width: 95px;
	}

	.workstatus-save:hover{color: white;}
	
	.workwirte-container {margin-bottom: 11px;}
	
	.delete {
		display: none;
	    border: solid 1px rgba(0, 0, 0, .1);
	    border-radius: 5px;
	    background-color: white;
	    height: 25px;
	    width: 25px;
	    font-size: 9pt;
	    position: absolute;
	    right: -4%;
	    top: 23%;
		z-index: 9999 !important;
	    font-weight: 700;
	    color: #e60000;
	    padding: 0;
	}
	.delete:hover {
	    color: #e60000;
	}
	
	.seldate {
		background-color: white;
		position: relative; 
		z-index: 1;
	}
	
	/* 차트 */
	.chartBox {
	    margin: 0;
	    padding: 0;
	    font-family: sans-serif;
	    width: 978px;
	    border-radius: 20px;
	    background: white;
	    position: absolute;
	    left: 18.85%;
	    top: 26.1%;
	}
     
	#myChart {
		height: 416px;
		width: 1122px !important;
	}
</style>

<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		var attendancetype;
		var todaydate;
		
		
		/* 차트 */
		// setup 
	    const data = {
	   	  //labels: ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'],
	      labels: ['', '', '', '', '', '', ''],
	      datasets: [{
	        label: '',
	        barThickness: 18,
	        borderRadius: 20,
	        //data: [18, 12, 6, 9, 12, 3, 9],
	        data: [
	        	[8, 19],
	        	[9, 18.5],
	        	[9, 19.33],
	        	[9, 18.1],
	        	[9, 12],[12, 18],
	        	[9, 24],
	        ],
	        backgroundColor: [
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(255,255,255,1)',
	          'rgba(255,255,255,1)',
	          //'rgba(75, 192, 192, 0.2)',
	        ],
	        borderColor: [
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(4,191,173,1)',
	          'rgba(255,255,255,1)',
	          'rgba(255,255,255,1)',
	          //'rgba(75, 192, 192, 0.2)',
	        ],
	        borderWidth: 0.25,
	        borderSkipped: false
	      }]
	    };

		
	    // config 
	    const config = {
	      type: 'bar',
	      data,
	      options: {
    	    ticks: {
	            min: 0,
	            max: 24,
	            stepSize: 1,
	            //display: false
	        },
	        scaleLabel: {
	            display: true,
            },
	    	maintainAspectRatio :false,  
	    	indexAxis:'y',  // 수평차트
	        scales: {
	          y: {
	            beginAtZero: true
	          },
	          x: {
	            beginAtZero: true,
	            display: false, // 눈금 제거
	            stacked: true // ?
	          }
	        },
	    	plugins: {
	   		   legend: {
	   		    display: false,
	   		  },
	   		  tooltip: {
	   			enabled: false
	   		  }
	    	},
	      }
	    };

	    // render init block
	    const myChart = new Chart(
	      document.getElementById('myChart'),
	      config
	    );
		
		
		
		
		
		
		$("a#attendance").addClass("list_iscurrent");
	 	$("a#dayoff").removeClass("list_iscurrent");
		
	 	// 날짜피커
	 	flatpickr.localize(flatpickr.l10ns.ko);
	 	flatpickr($(".dateSelector"));
		$(".dateSelector").flatpickr({
			dateFormat: "Y. m. d",
			defaultDate: new Date(),
			local: 'ko'
		});
		

		// 오프캔버스 타임피커
	 	flatpickr.localize(flatpickr.l10ns.ko);
	 	flatpickr($(".timeSelector"));
		$(".timeSelector").flatpickr({
			enableTime: true,
		    noCalendar: true,
		    dateFormat: "H:i",
			local: 'ko'
	 	}); 
	 	 
		
		// 오늘 버튼 클릭시 오늘로 날짜 설정
		$(".today").click(function(){
			$(".dateSelector").flatpickr({
				defaultDate:new Date(),
				dateFormat: "Y. m. d"
			});
			getSelectedDate();
			putDate();
			putTodayDot();
		});
		
		// flatpickr에서 선택된 날짜 구하고 날짜를 넣어주기
		getSelectedDate();
		putDate();
		putTodayDot();
		// flatpickr 날짜 변경 이벤트
		$(".dateSelector").change(function(){
			getSelectedDate();
			putDate();
			putTodayDot();
		});
	 	
	 	// 시간 infobox
	 	$(".workingiweek-infobox").hide();
	 	$(".workingweek-info").hover(function(){
	 		$(".workingiweek-infobox").fadeIn("fast");
	 	}, function(){
	 		$(".workingiweek-infobox").fadeOut("fast");
	 	});
	 	
	 	// sum막대바 info박스
	 	$(".workingweek-sumbar-infobox").hide();
	 	$(".workingweek-sumbar-default").hover(function(){
	 		$(".workingweek-sumbar-infobox").fadeIn("fast");
	 	}, function(){
	 		$(".workingweek-sumbar-infobox").fadeOut("fast");
	 	});
	 	
	 	// hover
	 	$(".workingweek-sumbar-goal-infobox").hide();
	 	$(".workingweek-sumbar-goal").hover(function(){
	 		$(".workingweek-sumbar-goal-infobox").fadeIn("fast");
	 	}, function(){
	 		$(".workingweek-sumbar-goal-infobox").fadeOut("fast");
	 	});
	 	
	 	
	 	
	 	// offcanvas 열기
	 	$(".workingweek > table > tbody > tr:first-child ~ tr").click(function(e){
	 		$('.offcanvas').offcanvas('show');
	 		
	 		// header에 날짜를 알아오기
	 		const yyyymmdd = $(e.target).parent().find("span.date").text();
	 		const yyyy = yyyymmdd.substr(0,4);
	 		const mm = yyyymmdd.substr(6,2);
	 		const dd = yyyymmdd.substr(10,2);
	 		$("#offcanvasScrollingLabel").text(yyyy+"년 "+mm+"월 "+dd+"일");
	 		todaydate = yyyy+"년 "+mm+"월 "+dd+"일"
		 	
	 		
	 		const workTimebyDay = $(e.target).parent().find("div.workingtotalhourByday > span").text();
	 		//console.log("workTimebyDay : "+workTimebyDay);
 			
	 		if(workTimebyDay == "시간"){
	 			$("div.ml-2 > span").text("0시간");
			} else {
				$("div.ml-2 > span").text(workTimebyDay);
			}
	 		
	 		
	 		
	 		// 총 근무시간 조회해오기
			<%-- $.ajax({
				url:"<%= request.getContextPath()%>/getTotalTime.up",
				data:{"seldate":todaydate},
				//type:"POST",
				async:false,
				dataType:"JSON",  
				success:function(json){ 
					let html = '';
					
					/* 
	     			if(json.workTime != ' ' || json.workTime != 0) {
     					
     					document.getElementById("workTime").textContent = json.workTime;
	     				if(json.workMin != ' ' || json.workMin != 0) {
	     					document.getElementById("workMin").textContent = json.workMin;
							html = '<div class="workingtotalhourByday ml-2"><span class="ml-1" id="workTime"></span>시간 <span class="ml-1" id="workMin"></span>분</div>';
	     				}
	     				else{
	     					document.getElementById("workMin").textContent = 0;
							html = '<div class="workingtotalhourByday ml-2"><span class="ml-1" id="workTime"></span>시간 <span class="ml-1" id="workMin"></span>분</div>';
	     				}
	     			}
	     			else {
	     				document.getElementById("workTime").textContent = 0;
	     				html = '<div class="workingtotalhourByday ml-2"><span class="ml-1" id="workTime"></span>시간</div>';
	     			}
   	         		*/
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }					
			}); --%>
	 		
	 		
	 		// 근무상태 조회해오기
			$.ajax({
				url:"<%= request.getContextPath()%>/attendanceView.up",
				data:{"seldate":todaydate},
				type:"POST",
				async:false,
				dataType:"JSON",  
				success:function(json){ 
					let html = "";
					
					if(json.length != 0) {
					
			     		$.each(json, function(index, item){
			     			
			     			html += '<div class="workwirte-container dropdown" id="workwirte-container0">'
									+ '<div id="worktype-container0" class="worktype">'
									+ '<div class="workwritebox btn" id="workwriteStatus0" style="padding: 0.375rem 0.5rem 0.375rem 1rem;">'
										+ '<img class="attimg" src="<%= ctxPath%>/resources/images/'+item.adcatgo+'.png" width="16px" readonly/>'
										+ '<span readonly>'+item.adcatgo+'</span>'
									+ '</div>'
									
									/* + '<div class="dropdown-toggle workwritebox btn" id="workwriteStatus0" data-bs-toggle="dropdown" aria-expanded="false">'
										+ '<img src="'+item.adImg+'" width="16px"/>'
										+ '<span>'+item.adcatgo+'</span>'
									+ '</div>'
									
									+ '<ul class="dropdown-menu workStatusbox" id="workStatusbox" aria-labelledby="workwriteStatus" style="min-width: 7rem;">'
										+ '<li>'
											+ '<a id="statusval-working" class="dropdown-item" href="#"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/325/woman-technologist_1f469-200d-1f4bb.png" width="16px"/> 근무 </a> '
										+ '</li>'
										+ '<li>'
											+ '<a id="statusval-remote" class="dropdown-item" href="#"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/72/apple/325/laptop_1f4bb.png" width="16px"/> 원격근무 </a> '
										+ '</li>'
										+ '<li>'
											+ '<a id="statusval-outside" class="dropdown-item" href="#"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/72/apple/325/oncoming-automobile_1f698.png" width="16px"/> 외근 </a> '
										+ '</li>'
										+ '<li>'
											+ '<a id="statusval-trip" class="dropdown-item" href="#"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/72/apple/325/spiral-calendar_1f5d3-fe0f.png" width="16px"/> 출장 </a> '
										+ '</li>'
									+ '</ul> ' */
									+ '</div> '
									
									+ '<div class="workStartbox" id="workwriteStart">'
										+ '<input type="text" class="timeSelector stime" id="startTime" value="'+item.startTime+'" readonly />'
									+ '</div>'
									+ '<div style="display:inline-block;">'
										+ '<i class="fa-solid fa-arrow-right" style="color: #C6C6C6"></i>'
									+ '</div>'
									+ '<div class="workEndbox" id="workwriteEnd">'
										+ '<input type="text" class="timeSelector etime" id="endTime" value="'+item.endTime+'" readonly />'
									+ '</div>'
									
									+ '<button type="button" class="delete btn" onclick="del_stepattendanceAjax(event, '+item.adno+')">X</button>'
									+ '<input type="hidden" id="employee_no" value="${sessionScope.loginuser.employee_no}"/>'
								  + '</div>';
								  
			     			}); 
						}
	     			
	   	         		$(".attendanceplus").html(html); 
	   	         		
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }					
			});
		 	
		 	
	 	});// end of $(".workingweek > table > tbody > tr:first-child ~ tr").click------------
	 	
	 	
	 	// 근무형태 containter hover 시 삭제버튼 생성
	 	$(document).on("mouseenter", "div.workwirte-container", function(e){
	 		$("button.delete").css("display","block");
	 	}); 
	 	$(document).on("mouseleave", "div.workwirte-container", function(e){
	 		$("button.delete").css("display","none");
	 	}); 
	 	
	 	
		
		// 휴지통 버튼 클릭시
		$("#goAllDel").click(function(){
		
			del_allDelAjax();  // 근무박스 전부 없애버리기
			
			// 근무상태 전체 삭제하기
	 		$.ajax({
				url:"<%= request.getContextPath()%>/attendancaAllDel.up",
				traditional: true,
				data:{"seldate":todaydate},
				//type:"POST",
				dataType:"JSON",   
				success:function(json){  
					alert("모두 삭제되었습니다.");
					location.href="javascript:location.reload(true)"; // 현재 페이지로 이동(==새로고침) 서버에 가서 다시 읽어옴.
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }					
			});
		
		});// end of $("#goSave").click(function()----------
		
		
		
	 	
	 	// 저장하기 버튼 클릭시
	 	$("#goSave").click(function(){
	 		
	 		if(attendancetype == null || attendancetype == '') {
	 			attendancetype = '근무'
	 		}
	 		
	 		var att = [];
	 		var start = [];
	 		var end = [];
	 		
	 		var select = $(".workwirte-container"); // 전체박스 번호
	 		
	 		for (var i=0; i<select.length; i++) { // 근무형태
            	att.push(select[i].innerText); 
            }
	 		
	 		var stimearr = $(".stime");
			for (var y=0; y<stimearr.length; y++) { // 시작 시간
				start.push($(".stime").eq(y).val());
			}
			
	 		var etimearr = $(".etime");
			for (var z=0; z<etimearr.length; z++) { // 종료시간
				end.push($(".etime").eq(z).val());
			}
	 		
	 		// 근무상태 저장하기
	 		$.ajax({
				url:"<%= request.getContextPath()%>/attendancadd.up",
				traditional: true, // 배열 넘겨줄때 필요
				data:{"attendancetypeArr":att
					 ,"startTimeArr":start
					 ,"endTimeArr":end
					 ,"todaydate":todaydate},
				//type:"POST",
				dataType:"JSON",   // AttendanceController.java 로 data 를 보낸다.
				success:function(json){   // AttendanceController.java 에서 jsonObj.put() 한 json.name 을 받아옴.
					alert("근무 상태가 저장되었습니다.");
					location.href="javascript:location.reload(true)"; // 현재 페이지로 이동(==새로고침) 서버에 가서 다시 읽어옴. 
					
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }					
			});
			
	 	});// end of $("#goSave").click(function()----------
	 	
	 			
	});//end of $(document).ready(function(){})------------------
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	// function declaration
	
	// flatpickr에 선택된 날짜를 구하는 함수
	var thisWeek = []; // 주차 데이터 넣는 용
	var thisWeekArr = []; //오늘날짜 dot 검사용
	function getSelectedDate(){
		//flatpickr에 선택된 날짜 구하기
	 	var selected_date = $(".dateSelector").val();
	 	var selected_yy = selected_date.substr(0,4);
	 	var selected_mm = selected_date.substr(6,2);
	 	
	 	var selected_dd = selected_date.substr(10,2);
	 	var valDate = new Date(selected_yy, selected_mm-1, selected_dd);
	 	//console.log("selected_date : " +selected_date); // 2022. 12. 07

	 	// 주차 구하기
		var currentDay = new Date(valDate);
		var theYear = currentDay.getFullYear();
		var theMonth = currentDay.getMonth();
		var theDate  = currentDay.getDate();
		var theDayOfWeek = currentDay.getDay();
		//console.log("theDate : " +theDate); // 7일(현재날짜)
		//console.log("theDayOfWeek : " +theDayOfWeek); // 이번주 세번째인 수요일 => 3
		
		
		for(var i=1; i<8; i++) {
			var resultDay = new Date(theYear, theMonth, theDate + (i - theDayOfWeek));
			var yyyy = resultDay.getFullYear();
			var mm = Number(resultDay.getMonth()) + 1;
			var dd = resultDay.getDate();  // 이번주 일요일 날짜 => 11
			//console.log("resultDay : " +resultDay);
			//console.log("yyyy : " +yyyy);
			//console.log("mm : " +mm);
			//console.log("dd : " +dd);
			
			mm = String(mm).length === 1 ? '0' + mm : mm;
			dd = String(dd).length === 1 ? '0' + dd : dd;
			
			thisWeek[i] = yyyy + '. ' + mm + '. ' + dd;
			thisWeekArr[i] = new Date(yyyy, mm-1, dd);
		}
	}//end of getSelectedDate()
	
	
	// 선택된 날짜를 넣어주는 함수(메인★)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	function putDate(){
		$(".date").each(function(index, item){
			$(item).html(thisWeek[index+1]);
			
			//console.log("thisWeek[index+1] >>>"+thisWeek[index+1]);
			thisWeekDate = thisWeek[index+1];
			
			// 총 근무시간 및 시작,종료시간 조회해오기
			$.ajax({
				url:"<%= request.getContextPath()%>/getworkTimebyDay.up",
				traditional: true,
				data:{"thisWeekDate":thisWeekDate},
				//type:"POST",
				async:false,
				dataType:"JSON",  
				success:function(json){ 
					console.log(JSON.stringify(json));  // 배열타입도 모두 찍을 수 있다.
					//console.log("JSON.workTime : "+json[0].workTime);
					//console.log("JSON.workMin : "+json[0].workMin);
					
					if(json.length <= 0){
						$("#workTime"+index).css("display","none");
					} else {
						if(json[0].workTime != 0 && json[0].workMin != 0) {
							$("#workTime"+index+"> span").text(json[0].workTime+"시간 "+json[0].workMin+"분"); // json에서 받은 배열 리스트는 한행이므로 [0] 번째 인덱스에 모두 저장되있음.
						} else if(json[0].workTime != 0 && json[0].workMin == 0) {
							$("#workTime"+index+"> span").text(json[0].workTime+"시간");
						}
					}
					
					// 총 근무시간 합 구하기
					
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }					
			});
			
			
		});
		
		
	}//end of putDate()
	
	// 선택된 날짜가 오늘날짜와 같으면 오늘날짜 dot를 넣어주는 함수
	function putTodayDot(){
		html = '<div class="spinner"><div class="double-bounce1"></div><div class="double-bounce2"></div></div>';
		//같은 날짜인지 비교하는 함수
		const isSameDate = (date1, date2) => {
			return date1.getFullYear() === date2.getFullYear() && date1.getMonth() === date2.getMonth() && date1.getDate() === date2.getDate();
		}
		var nowdate = new Date();
		thisWeekArr.forEach(function(item, index, array){
			if(isSameDate(nowdate, item)){ //같은 날짜라면
				$("#datedot"+index).html(html);
				return; //반복문 종료
			} else{
				$("#datedot"+index).html("");
			}
			
		});
	}//end of putTodayDot()
	
	
     var i = 0;   
	/* 근무 박스 추가 */
	function attendanceplus(){
     ++i;
     var html = '<div class="workwirte-container dropdown" id="workwirte-container'+i+'" >'
                	+'<div id="worktype-container'+i+'" class="worktype" onclick="add_workwriteStatus('+i+',event)">'
	                	+'<div class="dropdown-toggle workwritebox btn" id="workwriteStatus'+i+'" data-bs-toggle="dropdown" aria-expanded="false" style="padding: 0.375rem 0.5rem 0.375rem 1rem;">'
			               +'<img class="attimg" src="<%= ctxPath%>/resources/images/근무.png" width="16px"/>'
			                  +'<span>근무</span>'
		                +'</div>'
		                  +'<ul class="dropdown-menu workStatusbox" id="workStatusbox'+i+'" aria-labelledby="workwriteStatus" style="min-width: 7rem;">'
		                  +'<li>'
		                     +'<a id="statusval-working" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/근무.png" width="16px"/>근무</a>'
		                  +'</li>'
		                  +'<li>'
		                     +'<a id="statusval-remote" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/원격근무.png" width="16px"/>원격근무</a>'
		                  +'</li>'
		                  +'<li>'
		                     +'<a id="statusval-outside" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/외근.png" width="16px"/>외근</a>'
		                  +'</li>'
		                  +'<li>'
		                     +'<a id="statusval-trip" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/출장.png" width="16px"/>출장</a>'
		                  +'</li>'
		                +'</ul>'
	                +'</div>'
	               
	                +'<div class="workStartbox" id="workwriteStart">'
	                  +'<input type="text" class="timeSelector stime" id="startTime'+i+'" name="timepicker" value="" placeholder="시작 시각"/>   '               
	                +'</div>'
	                +'<div style="display:inline-block;">'
	                  +'<i class="fa-solid fa-arrow-right" style="color: #C6C6C6"></i>'
	                +'</div>'
	               
	                +'<div class="workEndbox" id="workwriteEnd">'
	                  +'<input type="text" class="timeSelector etime" id="endTime'+i+'" name="timepicker" value="" placeholder="종료 시각"/>'                  
	                +'</div>'
	                +'<button type="button" class="delete btn" onclick="del_stepattendance(event)">X</button>'
	                +'<input type="hidden" id="employee_no" value="${sessionScope.loginuser.employee_no}"/>'
	             +'</div>'
                +'</div>';
	       $("div.attendanceplus").append(html);
	       $(document).find("input[name=timepicker]").removeClass('hasDatepicker').flatpickr({
	            enableTime: true,
	            noCalendar: true,
	            dateFormat: "H:i",
	            local: 'ko'});  
  	 }
	
	
	/* 근무상태 박스 한개 비우기 */
	function del_stepattendance(e){
		const del_box = $(e.target).parent();
		//console.log("del_box =>"+del_box)
		del_box.remove();
		//$("#workwirte-container"+num).remove();
		
	}// end of function del_stepattendance(e)--------------
	
	/* 근무상태 박스 한개 비우기(ajax 처리) */
	function del_stepattendanceAjax(e, adno){
		const del_box = $(e.target).parent();
		del_box.remove();
		
		// 선택한 근무상태 삭제하기
  		$.ajax({
 			url:"<%= request.getContextPath()%>/attendancadel.up",
 			traditional: true,
 			data:{"adno":adno},
 			//type:"POST",
 			dataType:"JSON",  
 			success:function(json){   
 				
 				alert("선택한 근무 상태가 삭제되었습니다.");
 				location.href="javascript:location.reload(true)"; // 현재 페이지로 이동(==새로고침) 서버에 가서 다시 읽어옴. 
 			},
 			error: function(request, status, error){
 	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 	        }					
 		});
		
	}// end of function del_stepattendanceAjax(e, adno)-------------- 
	
	
	/* 근무상태 박스 전부 비우기(ajax 처리) */
	function del_allDelAjax(){
		i = 0;
		$(".attendanceplus").empty();
	}
	
	
	// 근무형태 변경하기
	let id = null;
	function add_workwriteStatus(num, e){
		// num = $(e.target).attr("id");
		id = $(e.target).attr("id");
		//console.log("id 값 =>"+id);
		//console.log("num 값 =>"+num);
		const selectedimg = $(e.target).find("img").attr("src");
 		const selectedtxt = $(e.target).text();
 		
 		//console.log("selectedimg 값 =>"+selectedimg);
		//console.log("selectedtxt 값 =>"+selectedtxt);
 		$("#workwriteStatus"+num +" > img").attr("src", selectedimg);
 		$("#workwriteStatus"+num +" > span").text(selectedtxt);
 		//attendancetype = selectedtxt;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</script>

<div class="attendance-container">
	<div class="datebox margin-container">
		<span class="" style="display: inline-block; width: 140px; ">
			<input class="dateSelector attendance-dateSelector">
			<i class="fas fa-chevron-down ad-downarrow"></i>
		</span>
		<button type="button" class="today btn">오늘</button>
	</div>
	<hr class="HRhr"/>
	<div class="workingweek-sum margin-container">
		<span class="fontsize-basic"><span style="font-weight: 600; font-size: 14pt;">16시간</span> / 52시간</span>
		<div class="workingweek-info">
			<i class="fa-solid fa-circle-info ml-2" style="color: #C6C6C6; font-size: 9pt;"></i>
			<div class="workingiweek-infobox">
				<table>
					<tr><td>소정근무</td><td style="color:white;">16시간</td></tr>
					<tr><td>기본</td><td>14시간 30분</td></tr>
					<tr><td>야간</td><td>1시간 30분</td></tr>
					<tr><td colspan="2"><hr class="HRhr"style="margin:5px 0 5px 0; background-color:#B1B5B9; border:none; height:1px;"/></td></tr>
					<tr><td>합계</td><td class="workingweek-total">16시간</td></tr>
				</table>
			</div>
		</div>
		<div class="workingweek-sumbar">
			<div class="workingweek-sumbar-default"></div>
			<div class="workingweek-sumbar-infobox">
				<table>
					<tr><td>기본</td><td>14시간 30분</td></tr>
					<tr><td>야간</td><td>1시간 30분</td></tr>
					<tr><td colspan="2"><hr class="HRhr"style="margin:5px 0 5px 0; background-color:#B1B5B9; border:none; height:1px;"/></td></tr>
					<tr><td>합계</td><td class="workingweek-total">16시간</td></tr>
				</table>
			</div>
			<div class="workingweek-sumbar-goal"></div>
			<div class="workingweek-sumbar-goal-infobox">
				<table><tr><td>목표시간</td><td>40시간</td></tr></table>
			</div>
		</div>
	</div>
	<div class="workingweek">
		<table class="fontsize-basic worktable" style="position: relative; z-index: 9;">
			<tr class="workinghour">
				<td></td>
				<c:forEach var="i" begin="0" end="23">
					<td colspan="2">${i}</td>
				</c:forEach>
			</tr>
			<tr>
				<td class="mon seldate">
					<span class="date"></span>(월)<span id="datedot1"></span>
					<div class="workingtotalhourByday" id="workTime0"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach>
				<div class="working-recordbar"></div> --%>
			</tr>
			<tr>
				<td class="tue seldate" style="padding: 15px 0 13px 5px;"><span class="date"></span>(화)<span id="datedot2"></span>
					<div class="workingtotalhourByday" id="workTime1"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
			<tr>
				<td class="wed seldate" style="padding: 15px 0 14px 5px;"><span class="date"></span>(수)<span id="datedot3"></span>
					<div class="workingtotalhourByday" id="workTime2"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
			<tr>
				<td class="thu seldate"><span class="date"></span>(목)<span id="datedot4"></span>
					<div class="workingtotalhourByday" id="workTime3"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
			<tr>
				<td class="fri seldate" style="padding: 16px 0 16px 5px;"><span class="date"></span>(금)<span id="datedot5"></span>
					<div class="workingtotalhourByday" id="workTime4"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
			<tr class="font-red">
				<td class="sat seldate"><span class="date"></span>(토)<span id="datedot6"></span>
					<div class="workingtotalhourByday" id="workTime5"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
			<tr class="font-red">
				<td class="sun seldate"><span class="date"></span>(일)<span id="datedot7"></span>
					<div class="workingtotalhourByday" id="workTime6"><span>시간</span></div>
				</td>
				<%-- <c:forEach var="i" begin="0" end="47"><td></td></c:forEach> --%>
			</tr>
		</table>
		<div class="chartBox">
        	<canvas id="myChart"></canvas>
        </div>
		
		
		
		
		
		<!-- 오프캔버스 시작 -->
		<div class="offcanvas offcanvas-end" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1" id="offcanvasScrolling" aria-labelledby="offcanvasScrollingLabel">
		  <div class="offcanvas-header">
		    <div class="offcanvas-title headeroffcanvas" id="offcanvasScrollingLabel"></div>
		    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button> <%-- input 저장하지 않은 값 비우기 --%>
		  </div>
		  <hr class="HRhr"style="margin: 0; border:none; height:1px; background-color: rgba(242, 242, 242);"/>
		  <div class="offcanvas-body">
		  	<form id="attendance_frm">
			  	<div>
			  		<div class="todayworkStatus-container">
				  		<span>총 근무</span>
				  		<!-- <div class="workingtotalhourByday ml-2"><span class="ml-1" id="workTime">0</span>시간 <span class="ml-1" id="workMin"></span>분</div> -->
				  		<div class="workingtotalhourByday ml-2"><span class="ml-1" id="workTime"></span></div>
				  		<div class="atnotice">(휴게시간 포함)</div>
				  		<div class="line"></div>
			  		</div>
			  		<!-- 근무 1개  -->
			  	    <div class="attendanceplus">
				  	    <div class="workwirte-container dropdown" id="workwirte-container0">
				  	    <div id="worktype-container0" class="worktype" onclick="add_workwriteStatus(0,event)">
							<div class="dropdown-toggle workwritebox btn" id="workwriteStatus0" data-bs-toggle="dropdown" aria-expanded="false" style="padding: 0.375rem 0.5rem 0.375rem 1rem;">
								<!-- <img class="attimg" src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/325/woman-technologist_1f469-200d-1f4bb.png" width="16px"/> -->
								<img class="attimg" src="<%= ctxPath%>/resources/images/근무.png" width="16px"/>
								<span>근무</span>
							</div>
	 						<ul class="dropdown-menu workStatusbox" id="workStatusbox" aria-labelledby="workwriteStatus" style="min-width: 7rem;">
								<li>
									<a id="statusval-working" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/근무.png" width="16px"/>
										근무
									</a>
								</li>
								<li>
									<a id="statusval-remote" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/원격근무.png" width="16px"/>
									      원격근무
									</a>
								</li>
								<li>
									<a id="statusval-outside" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/외근.png" width="16px"/>
										외근
									</a>
								</li>
								<li>
									<a id="statusval-trip" class="dropdown-item" href="#"><img src="<%= ctxPath%>/resources/images/출장.png" width="16px"/>
										출장
									</a>
								</li>
							</ul> 
						</div>
							
							<div class="workStartbox" id="workwriteStart">
								<input type="text" class="timeSelector stime" id="startTime" name="timepicker" value="" placeholder="시작 시각"/>						
							</div>
							<div style="display:inline-block;">
								<i class="fa-solid fa-arrow-right" style="color: #C6C6C6"></i>
							</div>
							
							<div class="workEndbox" id="workwriteEnd">
								<input type="text" class="timeSelector etime" id="endTime" name="timepicker" value="" placeholder="종료 시각"/>						
							</div>
							<!-- <button type="button" class="delete btn" onclick="del_stepattendance(event)"><i class="fas fa-times"></i></button> -->
							<button type="button" class="delete btn" onclick="del_stepattendance(event)">X</button>
							<input type="hidden" id="employee_no" value="${sessionScope.loginuser.employee_no}"/>
						</div>
					</div>
					<!-- 근무 1개 끝  -->
					
					<div class="buttons">
				  		<div class="workadd" onclick="attendanceplus(1)">
				  			<div><i class="fa-solid fa-circle-plus" style="color: #5E9FF2;"></i><span style="color:#5E9FF2; margin-left: 5pt;">추가하기</span></div>
			  			</div>
			  			<div class="workstatus-buttoncontainer">
			  				<button type="button" class="workstatusall-del btn" id="goAllDel"><i class="fa-solid fa-trash-can" ></i></button> <%-- 전체 삭제하기 --%>
				  			<button type="button" class="workstatus-save gradientbtn btn" id="goSave">저장하기</button>
			  			</div>
					</div>
			  	</div>
		  	</form>
		  </div>
		</div>
		<!-- 오프캔버스 끝 -->
	</div>
</div>
