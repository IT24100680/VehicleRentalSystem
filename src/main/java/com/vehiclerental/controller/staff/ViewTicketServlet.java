package com.vehiclerental.controller.staff;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.TicketDAO;
import com.vehiclerental.model.Ticket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ViewTicketServlet extends HttpServlet {

    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
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

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

        String ticketIdStr = request.getParameter("id");

        if (ticketIdStr != null && !ticketIdStr.isEmpty()) {
            // View single ticket
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            if (ticket != null) {
                // Check authorization
                if (AppConstants.ROLE_ADMIN.equals(role) || ticket.getUserId() == userId) {
                    request.setAttribute("ticket", ticket);
                    request.getRequestDispatcher("/jsp/staff/ticketDetails.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/viewTickets?error=unauthorized");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/viewTickets?error=notfound");
            }
        } else {
            // View all tickets
            List<Ticket> tickets;

            if (AppConstants.ROLE_ADMIN.equals(role)) {
                tickets = ticketDAO.getAllTickets();
            } else {
                tickets = ticketDAO.getTicketsByUserId(userId);
            }

            request.setAttribute("tickets", tickets);
            request.getRequestDispatcher("/jsp/staff/viewTicket.jsp").forward(request, response);
        }
    }
}