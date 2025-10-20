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

public class DeleteTicketServlet extends HttpServlet {

    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
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
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));

        Ticket ticket = ticketDAO.getTicketById(ticketId);

        // Verify authorization
        if (ticket == null || ticket.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=unauthorized");
            return;
        }

        // Only allow delete if open
        if (!AppConstants.TICKET_OPEN.equals(ticket.getTicketStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=cannot_delete");
            return;
        }

        boolean success = ticketDAO.deleteTicket(ticketId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=delete_failed");
        }
    }
}