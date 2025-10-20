package com.vehiclerental.controller.feedback;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks();
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/jsp/admin/manageFeedbacks.jsp").forward(request, response);
    }
}