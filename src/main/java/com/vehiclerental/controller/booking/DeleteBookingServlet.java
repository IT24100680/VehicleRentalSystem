package com.vehiclerental.controller.booking;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DeleteBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        vehicleDAO = new VehicleDAO();
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
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        Booking booking = bookingDAO.getBookingById(bookingId);

        // Verify authorization
        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
            return;
        }

        // Only allow delete if pending or rejected
        if (!AppConstants.BOOKING_PENDING.equals(booking.getBookingStatus()) && 
            !AppConstants.BOOKING_REJECTED.equals(booking.getBookingStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=cannot_delete");
            return;
        }

        boolean success = bookingDAO.deleteBooking(bookingId);

        if (success) {
            // Update vehicle status back to available
            vehicleDAO.updateVehicleStatus(booking.getVehicleId(), AppConstants.VEHICLE_AVAILABLE);
            response.sendRedirect(request.getContextPath() + "/viewBookings?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=delete_failed");
        }
    }
}