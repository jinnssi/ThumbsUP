package com.spring.attendance.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.finalproject.service.InterFinalprojectService;

@Controller
public class AttendanceController {
	@Autowired
	private InterFinalprojectService service;
	
	@RequestMapping(value = "/attendance.up")
	public String attendance(HttpServletRequest request) {
		return "attendance/attendance.tiles";
	}
	
	@RequestMapping(value = "/dayoff/index.up")
	public String dayoffI_index(HttpServletRequest request) {
		return "attendance/dayoff_index.tiles";
	}
	
	@RequestMapping(value = "/dayoff/detail.up")
	public String dayoff(HttpServletRequest request) {
		return "attendance/dayoff_detail.tiles";
	}
	
	
	
	
}