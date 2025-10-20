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

public class ViewFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String vehicleIdStr = request.getParameter("vehicleId");

        if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
            // View feedbacks for specific vehicle
            int vehicleId = Integer.parseInt(vehicleIdStr);
            List<Feedback> feedbacks = feedbackDAO.getFeedbacksByVehicleId(vehicleId);
            double avgRating = feedbackDAO.getAverageRating(vehicleId);
            int reviewCount = feedbackDAO.getFeedbackCount(vehicleId);

            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("vehicleId", vehicleId);
        } else {
            HttpSession session = request.getSession(false);

            if (session != null && session.getAttribute(AppConstants.SESSION_USER_ID) != null) {
                int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
                String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

                List<Feedback> feedbacks;

                if (AppConstants.ROLE_ADMIN.equals(role)) {
                    feedbacks = feedbackDAO.getAllFeedbacks();
                } else {
                    feedbacks = feedbackDAO.getFeedbacksByUserId(userId);
                }

                request.setAttribute("feedbacks", feedbacks);
            } else {
                // Public view - all feedbacks
                List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks();
                request.setAttribute("feedbacks", feedbacks);
            }
        }

        request.getRequestDispatcher("/jsp/feedback/feedbackList.jsp").forward(request, response);
    }
}
