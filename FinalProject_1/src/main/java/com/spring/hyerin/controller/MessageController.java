package com.spring.hyerin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.finalproject.common.FileManager;
import com.spring.finalproject.common.MyUtil;
import com.spring.hyerin.model.EmployeeVO;
import com.spring.hyerin.model.MessageVO;
import com.spring.hyerin.service.InterMessageService;

@Controller
public class MessageController {
	
	@Autowired
	private InterMessageService service;
	
	@Autowired
	private FileManager fileManager;

	@RequestMapping(value = "/message.up")
	public ModelAndView rl_messageHome(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String tab = request.getParameter("tab");
		if(tab == null) tab = "all";
		String mno = request.getParameter("mno");
		if(mno == null) mno = "";
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("tab", tab);
		paraMap.put("mno",mno);
		// 로그인된 유저의 employee_no 알아오기
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		String receiver = loginuser.getEmployee_no();
		paraMap.put("receiver", receiver);
		
		//현재 페이지 저장
		String cururl = getCurrentURL(request);
		if(cururl.contains("&tab")) {
			int firsttab = cururl.indexOf("&tab"); 
			cururl = cururl.replaceAll(cururl.substring(firsttab), "");
		}
		paraMap.put("cururl",cururl);
		
		// 로그인유저의 메시지리스트 불러오기
		List<Map<String,String>> mvoList = service.getmvoList(paraMap);
		
		//로그인 유저가 클릭한 메시지내용 1개 불러오기
		Map<String,String> mvo = service.getmvo(mno);
		
		mav.addObject("paraMap",paraMap);
		mav.addObject("mvo",mvo);
		mav.addObject("mvoList",mvoList);
		mav.setViewName("message/message_recieve.tiles");
		return mav;
	}
	
	
	@RequestMapping(value = "/message/content.up")
	public ModelAndView messageUnread(HttpServletRequest request, ModelAndView mav) {
		
		String mno = request.getParameter("mno");
		if(mno == null) mno = "";
		
		
		
		mav.addObject("mno",mno);
		mav.setViewName("tiles/message/message_content");
		return mav;
	}
	
	
	@RequestMapping(value = "/message/send.up")
	public ModelAndView messageRecieve(HttpServletRequest request, ModelAndView mav) {
		
		mav.setViewName("message/message_send.tiles");
		return mav;
	}
	
	@RequestMapping(value = "/message/temp.up")
	public ModelAndView messageTemp(HttpServletRequest request, ModelAndView mav) {
		
		mav.setViewName("message/message_temp.tiles");
		return mav;
	}
	
	@RequestMapping(value = "/message/write.up")
	public ModelAndView messageWrite(HttpServletRequest request, ModelAndView mav) {
		
		mav.setViewName("message/message_write.tiles");
		return mav;
	}
	
	@RequestMapping(value = "/message/memberList.up")
	public ModelAndView messageMemberList(HttpServletRequest request, ModelAndView mav) {
		
		mav.setViewName("tiles/message/message_memberList");
		return mav;
	}
	
	@RequestMapping(value = "/message/book.up")
	public ModelAndView messageBook(HttpServletRequest request, ModelAndView mav) {
		
		mav.setViewName("tiles/message/message_book");
		return mav;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	public String getCurrentURL(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String url = MyUtil.getCurrentURL(request);
		session.setAttribute("goBackURL", url);
		return url;
	}
}
