package com.vehiclerental.controller.booking;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.util.DateUtil;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

public class EditBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        vehicleDAO = new VehicleDAO();
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
        int bookingId = Integer.parseInt(request.getParameter("id"));

        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking != null && booking.getUserId() == userId) {
            // Allow edit if booking is pending or rejected
            if (AppConstants.BOOKING_PENDING.equals(booking.getBookingStatus()) || 
                AppConstants.BOOKING_REJECTED.equals(booking.getBookingStatus())) {
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/jsp/booking/editBooking.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/viewBookings?error=cannot_edit");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
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
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        Booking existingBooking = bookingDAO.getBookingById(bookingId);

        // Verify authorization
        if (existingBooking == null || existingBooking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
            return;
        }

        // Only allow edit if pending or rejected
        if (!AppConstants.BOOKING_PENDING.equals(existingBooking.getBookingStatus()) && 
            !AppConstants.BOOKING_REJECTED.equals(existingBooking.getBookingStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=cannot_edit");
            return;
        }

        // Get form parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String specialRequests = request.getParameter("specialRequests");

        Date startDate = DateUtil.stringToSqlDate(startDateStr);
        Date endDate = DateUtil.stringToSqlDate(endDateStr);

        // Validate dates
        if (!DateUtil.isValidDateRange(startDate, endDate)) {
            request.setAttribute("errorMessage", "Invalid date range! Return date must be on or after pickup date.");
            doGet(request, response);
            return;
        }

        if (DateUtil.isPastDate(startDate)) {
            request.setAttribute("errorMessage", "Pickup date cannot be in the past!");
            doGet(request, response);
            return;
        }

        // Calculate total days and amount
        int totalDays = DateUtil.calculateDaysBetween(startDate, endDate);
        if (totalDays <= 0) {
            totalDays = 1; // Minimum 1 day for same-day bookings
        }

        Vehicle vehicle = vehicleDAO.getVehicleById(existingBooking.getVehicleId());
        BigDecimal totalAmount = vehicle.getPricePerDay().multiply(new BigDecimal(totalDays));

        // Update booking
        Booking booking = new Booking();
        booking.setBookingId(bookingId);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setPickupLocation(ValidationUtil.sanitizeInput(pickupLocation));
        booking.setDropoffLocation(ValidationUtil.sanitizeInput(dropoffLocation));
        booking.setTotalDays(totalDays);
        booking.setTotalAmount(totalAmount);
        booking.setSpecialRequests(ValidationUtil.sanitizeInput(specialRequests));

        boolean success = bookingDAO.updateBooking(booking);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?success=updated");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
            doGet(request, response);
        }
    }
}