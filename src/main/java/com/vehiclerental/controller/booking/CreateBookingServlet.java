package com.vehiclerental.controller.booking;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.factory.RentalBookingFactory;
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

public class CreateBookingServlet extends HttpServlet {

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

        String vehicleIdStr = request.getParameter("vehicleId");

        if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

            if (vehicle != null && AppConstants.VEHICLE_AVAILABLE.equals(vehicle.getAvailabilityStatus())) {
                request.setAttribute("vehicle", vehicle);
                request.getRequestDispatcher("/jsp/booking/createBooking.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/vehicles?error=unavailable");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/vehicles");
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
        String vehicleIdStr = request.getParameter("vehicleId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String specialRequests = request.getParameter("specialRequests");

        // Validation
        if (ValidationUtil.isNullOrEmpty(vehicleIdStr) ||
                ValidationUtil.isNullOrEmpty(startDateStr) ||
                ValidationUtil.isNullOrEmpty(endDateStr)) {
            request.setAttribute("errorMessage", "Please fill all required fields!");
            doGet(request, response);
            return;
        }

        int vehicleId = Integer.parseInt(vehicleIdStr);
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
            totalDays = 1; // Minimum 1 day
        }

        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

        // Create booking via RentalBookingFactory
        Booking booking = RentalBookingFactory.createStandardRental(
                userId,
                vehicle,
                startDate,
                endDate,
                ValidationUtil.sanitizeInput(pickupLocation),
                ValidationUtil.sanitizeInput(dropoffLocation),
                ValidationUtil.sanitizeInput(specialRequests)
        );

        int bookingId = bookingDAO.createBooking(booking);

        if (bookingId > 0) {
            // Update vehicle status
            vehicleDAO.updateVehicleStatus(vehicleId, AppConstants.VEHICLE_BOOKED);

            response.sendRedirect(request.getContextPath() + "/viewBookings?success=created&bookingId=" + bookingId);
        } else {
            request.setAttribute("errorMessage", "Booking failed! Please try again.");
            doGet(request, response);
        }
    }
}