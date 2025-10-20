package com.vehiclerental.controller;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DashboardServlet extends HttpServlet {

    private UserDAO userDAO;
    private VehicleDAO vehicleDAO;
    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        vehicleDAO = new VehicleDAO();
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

        if (AppConstants.ROLE_ADMIN.equals(role)) {
            // Admin Dashboard Statistics
            int totalUsers = userDAO.getTotalUserCount();
            int totalVehicles = vehicleDAO.getTotalVehicleCount();
            int availableVehicles = vehicleDAO.getAvailableVehicleCount();
            int totalBookings = bookingDAO.getTotalBookingCount();
            int openTickets = ticketDAO.getOpenTicketCount();
            double totalRevenue = paymentDAO.getTotalRevenue();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("availableVehicles", availableVehicles);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("openTickets", openTickets);
            request.setAttribute("totalRevenue", totalRevenue);

            // Get recent bookings
            request.setAttribute("recentBookings", bookingDAO.getPendingBookings());
            request.setAttribute("recentPayments", paymentDAO.getPendingPayments());
            request.setAttribute("recentTickets", ticketDAO.getOpenTickets());

            request.getRequestDispatcher("/jsp/admin/adminDashboard.jsp").forward(request, response);
        } else {
            // Customer Dashboard
            int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);

            request.setAttribute("userBookings", bookingDAO.getBookingsByUserId(userId));
            request.setAttribute("userPayments", paymentDAO.getPaymentsByUserId(userId));
            request.setAttribute("userTickets", ticketDAO.getTicketsByUserId(userId));
            request.setAttribute("userFeedbacks", new FeedbackDAO().getFeedbacksByUserId(userId));

            request.getRequestDispatcher("/jsp/user/customerDashboard.jsp").forward(request, response);
        }
    }
}