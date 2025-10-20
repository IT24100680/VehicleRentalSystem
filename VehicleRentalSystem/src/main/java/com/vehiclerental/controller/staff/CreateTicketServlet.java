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

public class CreateTicketServlet extends HttpServlet {

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

        request.getRequestDispatcher("/jsp/staff/createTicket.jsp").forward(request, response);
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
        String category = request.getParameter("category");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        // Validation
        if (ValidationUtil.isNullOrEmpty(category) ||
                ValidationUtil.isNullOrEmpty(subject) ||
                ValidationUtil.isNullOrEmpty(description)) {
            request.setAttribute("errorMessage", "Please fill all required fields!");
            request.getRequestDispatcher("/jsp/staff/createTicket.jsp").forward(request, response);
            return;
        }

        // Create ticket
        Ticket ticket = new Ticket();
        ticket.setUserId(userId);
        ticket.setCategory(category);
        ticket.setSubject(ValidationUtil.sanitizeInput(subject));
        ticket.setDescription(ValidationUtil.sanitizeInput(description));
        ticket.setPriority(priority != null ? priority : "Medium");
        ticket.setTicketStatus(AppConstants.TICKET_OPEN);

        boolean success = ticketDAO.createTicket(ticket);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?success=created");
        } else {
            request.setAttribute("errorMessage", "Failed to create ticket!");
            request.getRequestDispatcher("/jsp/staff/createTicket.jsp").forward(request, response);
        }
    }
}