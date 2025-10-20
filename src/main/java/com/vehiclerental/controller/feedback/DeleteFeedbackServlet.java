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

public class DeleteFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));

        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        // Admin can delete any feedback, users can delete only their own
        if (feedback != null &&
                (AppConstants.ROLE_ADMIN.equals(role) || feedback.getUserId() == userId)) {

            boolean success = feedbackDAO.deleteFeedback(feedbackId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/viewFeedback?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/viewFeedback?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?error=unauthorized");
        }
    }
}