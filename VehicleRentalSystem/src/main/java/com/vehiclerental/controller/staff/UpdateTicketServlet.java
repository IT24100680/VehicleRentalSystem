package com.vehiclerental.controller.staff;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.TicketDAO;
import com.vehiclerental.model.Ticket;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateTicketServlet extends HttpServlet {

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
        int ticketId = Integer.parseInt(request.getParameter("id"));

        Ticket ticket = ticketDAO.getTicketById(ticketId);

        if (ticket != null && ticket.getUserId() == userId) {
            // Only allow edit if ticket is open
            if (AppConstants.TICKET_OPEN.equals(ticket.getTicketStatus())) {
                request.setAttribute("ticket", ticket);
                request.getRequestDispatcher("/jsp/staff/editTicket.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/viewTickets?error=cannot_edit");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=unauthorized");
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
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String action = request.getParameter("action");

        Ticket existingTicket = ticketDAO.getTicketById(ticketId);

        // Verify authorization
        if (existingTicket == null || existingTicket.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=unauthorized");
            return;
        }

        // Handle delete action
        if ("delete".equals(action)) {
            // Only allow delete if open
            if (!AppConstants.TICKET_OPEN.equals(existingTicket.getTicketStatus())) {
                response.sendRedirect(request.getContextPath() + "/viewTickets?error=cannot_delete");
                return;
            }

            boolean success = ticketDAO.deleteTicket(ticketId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/viewTickets?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/viewTickets?error=delete_failed");
            }
            return;
        }

        // Only allow edit if open
        if (!AppConstants.TICKET_OPEN.equals(existingTicket.getTicketStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=cannot_edit");
            return;
        }

        // Get updated data
        String category = request.getParameter("category");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        Ticket ticket = new Ticket();
        ticket.setTicketId(ticketId);
        ticket.setCategory(category);
        ticket.setSubject(ValidationUtil.sanitizeInput(subject));
        ticket.setDescription(ValidationUtil.sanitizeInput(description));
        ticket.setPriority(priority);

        boolean success = ticketDAO.updateTicket(ticket);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?success=updated");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
            doGet(request, response);
        }
    }
}