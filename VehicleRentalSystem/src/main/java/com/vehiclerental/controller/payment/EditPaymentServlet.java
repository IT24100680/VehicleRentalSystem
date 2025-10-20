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

public class EditPaymentServlet extends HttpServlet {

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

        Payment existingPayment = paymentDAO.getPaymentById(paymentId);

        // Verify authorization and status
        if (existingPayment == null || existingPayment.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=unauthorized");
            return;
        }

        if (!AppConstants.PAYMENT_PENDING.equals(existingPayment.getPaymentStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=cannot_edit");
            return;
        }

        // Get updated payment details
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String cardHolderName = request.getParameter("cardHolderName");

        Payment payment = new Payment();
        payment.setPaymentId(paymentId);
        payment.setPaymentMethod(paymentMethod);
        payment.setCardNumber(cardNumber);
        payment.setCardHolderName(ValidationUtil.sanitizeInput(cardHolderName));

        boolean success = paymentDAO.updatePayment(payment);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=update_failed");
        }
    }
}