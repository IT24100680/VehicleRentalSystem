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

public class AdminEditBookingServlet extends HttpServlet {

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
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking != null) {
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/jsp/admin/editBooking.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=notfound");
        }
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

        // Get form parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String specialRequests = request.getParameter("specialRequests");

        Date startDate = DateUtil.stringToSqlDate(startDateStr);
        Date endDate = DateUtil.stringToSqlDate(endDateStr);

        // Calculate total days and amount
        int totalDays = DateUtil.calculateDaysBetween(startDate, endDate);
        if (totalDays <= 0) {
            totalDays = 1;
        }

        Booking existingBooking = bookingDAO.getBookingById(bookingId);
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
            response.sendRedirect(request.getContextPath() + "/admin/bookings?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
        }
    }
}
