package com.vehiclerental.controller.booking;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ViewBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
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
        String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

        String bookingIdStr = request.getParameter("id");

        if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
            // View single booking
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking != null) {
                // Check authorization
                if (AppConstants.ROLE_ADMIN.equals(role) || booking.getUserId() == userId) {
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/jsp/booking/bookingDetails.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/viewBookings?error=notfound");
            }
        } else {
            // View all bookings
            List<Booking> bookings;

            if (AppConstants.ROLE_ADMIN.equals(role)) {
                bookings = bookingDAO.getAllBookings();
            } else {
                bookings = bookingDAO.getBookingsByUserId(userId);
            }

            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/jsp/booking/bookingList.jsp").forward(request, response);
        }
    }
}