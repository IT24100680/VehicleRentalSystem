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
import java.util.List;

public class ViewPaymentServlet extends HttpServlet {

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

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

        List<Payment> payments;

        if (AppConstants.ROLE_ADMIN.equals(role)) {
            payments = paymentDAO.getAllPayments();
        } else {
            payments = paymentDAO.getPaymentsByUserId(userId);
        }

        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/jsp/payment/paymentHistory.jsp").forward(request, response);
    }
}