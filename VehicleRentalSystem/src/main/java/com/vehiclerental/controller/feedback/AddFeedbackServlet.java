package com.vehiclerental.controller.feedback;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Feedback;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AddFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
        bookingDAO = new BookingDAO();
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
        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking != null && booking.getUserId() == userId) {
                // Only allow feedback for approved/completed bookings
                if (AppConstants.BOOKING_APPROVED.equals(booking.getBookingStatus()) ||
                        AppConstants.BOOKING_COMPLETED.equals(booking.getBookingStatus())) {
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/jsp/feedback/addFeedback.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/viewBookings?error=booking_not_completed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/selectBookingForFeedback");
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

        // Get form parameters
        String bookingIdStr = request.getParameter("bookingId");
        String vehicleIdStr = request.getParameter("vehicleId");
        String ratingStr = request.getParameter("rating");
        String comments = request.getParameter("comments");
        String isAnonymousStr = request.getParameter("isAnonymous");

        // Validation
        if (ValidationUtil.isNullOrEmpty(bookingIdStr) ||
                ValidationUtil.isNullOrEmpty(vehicleIdStr) ||
                ValidationUtil.isNullOrEmpty(ratingStr)) {
            request.setAttribute("errorMessage", "Please provide rating!");
            doGet(request, response);
            return;
        }

        int rating = Integer.parseInt(ratingStr);

        if (!ValidationUtil.isValidRating(rating)) {
            request.setAttribute("errorMessage", "Rating must be between 1 and 5!");
            doGet(request, response);
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        int vehicleId = Integer.parseInt(vehicleIdStr);
        boolean isAnonymous = "on".equals(isAnonymousStr) || "true".equals(isAnonymousStr);

        // Create feedback
        Feedback feedback = new Feedback();
        feedback.setUserId(userId);
        feedback.setBookingId(bookingId);
        feedback.setVehicleId(vehicleId);
        feedback.setRating(rating);
        feedback.setComments(ValidationUtil.sanitizeInput(comments));
        feedback.setAnonymous(isAnonymous);

        boolean success = feedbackDAO.addFeedback(feedback);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?success=added");
        } else {
            request.setAttribute("errorMessage", "Failed to submit feedback!");
            doGet(request, response);
        }
    }
}