package com.websockets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static RequestDispatcher rd;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
		response.setContentType("text/html");

		HttpSession session=request.getSession(true);
		String username=request.getParameter("username");
		session.setAttribute("username",username);

		if(username!=null && username.equals("doctor"))
		{
			rd=request.getRequestDispatcher("/doctor.jsp");
			rd.forward(request,response);
		}
		else if(username!=null && username.equals("ambulance"))
		{
			rd=request.getRequestDispatcher("/ambulance.jsp");
			rd.forward(request, response);
		}
		else if(username!=null)
		{
			rd=request.getRequestDispatcher("/patient.jsp");
			rd.forward(request, response);
		}
	}
}