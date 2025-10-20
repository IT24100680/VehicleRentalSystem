package com.vehiclerental.controller.staff;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.TicketDAO;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ResolveTicketServlet extends HttpServlet {

    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String status = request.getParameter("status");
        String adminResponse = request.getParameter("adminResponse");

        // Validation
        if (ValidationUtil.isNullOrEmpty(status) || ValidationUtil.isNullOrEmpty(adminResponse)) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=empty_response");
            return;
        }

        boolean success = ticketDAO.updateTicketStatus(ticketId, status,
                ValidationUtil.sanitizeInput(adminResponse));

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewTickets?success=resolved");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewTickets?error=resolve_failed");
        }
    }
}