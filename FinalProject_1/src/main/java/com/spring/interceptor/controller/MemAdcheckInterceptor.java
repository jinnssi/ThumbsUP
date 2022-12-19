package com.spring.interceptor.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.hyerin.model.EmployeeVO;

public class MemAdcheckInterceptor implements HandlerInterceptor{
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO)session.getAttribute("loginuser");
		
		if(loginuser == null) {
			String loc = request.getContextPath() + "/login.up";
			request.setAttribute("loc", loc);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			try {
				dispatcher.forward(request, response);
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
			return false;
		} else {
			
			String authority = loginuser.getAuthority();
			
			String s_requiredAt = "3,6,12,15,21,24,30,42,84,60,105,120,210,420,840,99";
			String[] requiredAt = s_requiredAt.split(",");
			
			boolean flag = false;
			for(String at : requiredAt) {
				if(authority.equals(at)) {
					flag = true;
					break;
				}
			}
			
			if (!flag) {
				String message = "접근 권한이 없습니다.";
				String loc = request.getContextPath();
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
				try {
					dispatcher.forward(request, response);
				} catch (ServletException | IOException e) {
					e.printStackTrace();
				}

				return false;
			}
			
		}
		
		return true;
		
	}
}
