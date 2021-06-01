package com.websockets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/loginAmbulance")

public class loginAmbulance extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static RequestDispatcher rd;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		
		HttpSession session = request.getSession(true);
		String username = request.getParameter("username");
		session.setAttribute("username", "ambulance");
		session.setAttribute("userval", username);
		
		rd = request.getRequestDispatcher("/ambulance.jsp");
		rd.forward(request, response);
		
	}
	
}