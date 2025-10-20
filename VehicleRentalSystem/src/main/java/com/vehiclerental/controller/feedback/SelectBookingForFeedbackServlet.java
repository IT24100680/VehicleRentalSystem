package com.vehiclerental.controller.feedback;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SelectBookingForFeedbackServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
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

        // Get all bookings for the user that are eligible for feedback
        List<Booking> allBookings = bookingDAO.getBookingsByUserId(userId);
        List<Booking> eligibleBookings = new ArrayList<>();

        for (Booking booking : allBookings) {
            // Only include approved or completed bookings
            if (AppConstants.BOOKING_APPROVED.equals(booking.getBookingStatus()) ||
                    AppConstants.BOOKING_COMPLETED.equals(booking.getBookingStatus())) {
                
                // Check if feedback already exists for this booking
                List<Feedback> existingFeedbacks = feedbackDAO.getFeedbacksByUserId(userId);
                boolean hasFeedback = false;
                
                for (Feedback feedback : existingFeedbacks) {
                    if (feedback.getBookingId() == booking.getBookingId()) {
                        hasFeedback = true;
                        break;
                    }
                }
                
                // Only include bookings that don't have feedback yet
                if (!hasFeedback) {
                    eligibleBookings.add(booking);
                }
            }
        }

        if (eligibleBookings.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewFeedback?error=no_bookings");
            return;
        }

        request.setAttribute("eligibleBookings", eligibleBookings);
        request.getRequestDispatcher("/jsp/feedback/selectBookingForFeedback.jsp").forward(request, response);
    }
}
