package com.vehiclerental.controller.payment;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ApprovePaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        String adminRemarks = request.getParameter("adminRemarks");

        boolean success = false;

        if ("approve_payment".equals(action)) {
            success = paymentDAO.updatePaymentStatus(paymentId, AppConstants.PAYMENT_APPROVED,
                    ValidationUtil.sanitizeInput(adminRemarks));
        } else if ("reject_payment".equals(action)) {
            success = paymentDAO.updatePaymentStatus(paymentId, AppConstants.PAYMENT_REJECTED,
                    ValidationUtil.sanitizeInput(adminRemarks));
        } else if ("approve_refund".equals(action)) {
            success = paymentDAO.updateRefundStatus(paymentId, "Approved",
                    ValidationUtil.sanitizeInput(adminRemarks));
        } else if ("reject_refund".equals(action)) {
            success = paymentDAO.updateRefundStatus(paymentId, "Rejected",
                    ValidationUtil.sanitizeInput(adminRemarks));
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?success=" + action);
        } else {
            response.sendRedirect(request.getContextPath() + "/viewPayments?error=" + action);
        }
    }
}