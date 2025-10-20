package com.vehiclerental.controller.payment;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.model.Payment;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class RefundRequestServlet extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        Payment payment = paymentDAO.getPaymentById(paymentId);

        if (payment != null) {
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/jsp/payment/refundRequest.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=notfound");
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
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        String refundReason = request.getParameter("refundReason");

        Payment payment = paymentDAO.getPaymentById(paymentId);

        // Verify authorization
        if (payment == null || payment.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=unauthorized");
            return;
        }

        // Only approved payments can request refund
        if (!AppConstants.PAYMENT_APPROVED.equals(payment.getPaymentStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=not_approved");
            return;
        }

        boolean success = paymentDAO.requestRefund(paymentId, ValidationUtil.sanitizeInput(refundReason));

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?success=refund_requested");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=refund_failed");
        }
    }
}