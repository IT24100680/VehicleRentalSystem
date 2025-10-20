package com.vehiclerental.controller.feedback;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.model.Feedback;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EditFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        int feedbackId = Integer.parseInt(request.getParameter("id"));

        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback != null && feedback.getUserId() == userId) {
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher("/jsp/feedback/editFeedback.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?error=unauthorized");
        }
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
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));

        Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);

        // Verify authorization
        if (existingFeedback == null || existingFeedback.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?error=unauthorized");
            return;
        }

        // Get updated data
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");
        String isAnonymousStr = request.getParameter("isAnonymous");
        boolean isAnonymous = "on".equals(isAnonymousStr) || "true".equals(isAnonymousStr);

        // Validation
        if (!ValidationUtil.isValidRating(rating)) {
            request.setAttribute("errorMessage", "Rating must be between 1 and 5!");
            doGet(request, response);
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setFeedbackId(feedbackId);
        feedback.setRating(rating);
        feedback.setComments(ValidationUtil.sanitizeInput(comments));
        feedback.setAnonymous(isAnonymous);

        boolean success = feedbackDAO.updateFeedback(feedback);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?success=updated");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
            doGet(request, response);
        }
    }
}