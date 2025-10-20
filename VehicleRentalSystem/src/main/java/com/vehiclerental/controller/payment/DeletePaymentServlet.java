package com.vehiclerental.controller.payment;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DeletePaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
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
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));

        Payment payment = paymentDAO.getPaymentById(paymentId);

        // Verify authorization
        if (payment == null || payment.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=unauthorized");
            return;
        }

        // Only pending payments can be deleted
        if (!AppConstants.PAYMENT_PENDING.equals(payment.getPaymentStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=cannot_delete");
            return;
        }

        boolean success = paymentDAO.deletePayment(paymentId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=delete_failed");
        }
    }
}