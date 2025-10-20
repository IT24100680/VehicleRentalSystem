package com.vehiclerental.controller.booking;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ApproveBookingServlet extends HttpServlet {

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
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String action = request.getParameter("action");
        String adminRemarks = request.getParameter("adminRemarks");

        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=notfound");
            return;
        }

        String status;
        String vehicleStatus;

        if ("approve".equals(action)) {
            status = AppConstants.BOOKING_APPROVED;
            vehicleStatus = AppConstants.VEHICLE_BOOKED;
        } else if ("reject".equals(action)) {
            status = AppConstants.BOOKING_REJECTED;
            vehicleStatus = AppConstants.VEHICLE_AVAILABLE;
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid_action");
            return;
        }

        boolean success = bookingDAO.updateBookingStatus(bookingId, status,
                ValidationUtil.sanitizeInput(adminRemarks));

        if (success) {
            // Update vehicle status
            vehicleDAO.updateVehicleStatus(booking.getVehicleId(), vehicleStatus);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?success=" + action + "d");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=" + action);
        }
    }
}