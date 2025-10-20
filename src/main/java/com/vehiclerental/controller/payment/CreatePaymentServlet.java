package com.vehiclerental.controller.payment;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Payment;
import com.vehiclerental.util.ValidationUtil;
import com.vehiclerental.strategy.PaymentStrategy;
import com.vehiclerental.strategy.PaymentContext;
import com.vehiclerental.strategy.PaymentResult;
import com.vehiclerental.strategy.PaymentStrategyFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

public class CreatePaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
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
        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking != null && booking.getUserId() == userId) {
                // Check if booking is approved
                if (AppConstants.BOOKING_APPROVED.equals(booking.getBookingStatus())) {
                    // Check if payment already exists
                    Payment existingPayment = paymentDAO.getPaymentByBookingId(bookingId);

                    if (existingPayment == null) {
                        request.setAttribute("booking", booking);
                        request.getRequestDispatcher("/jsp/payment/makePayment.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/viewPayments?error=already_paid");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/viewBookings?error=not_approved");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/viewBookings");
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

        // Get form parameters
        String bookingIdStr = request.getParameter("bookingId");
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String cardHolderName = request.getParameter("cardHolderName");
        String cvv = request.getParameter("cvv");
        String expiryDate = request.getParameter("expiryDate");
        String paypalEmail = request.getParameter("paypalEmail");
        String bankName = request.getParameter("bankName");
        String accountNumber = request.getParameter("accountNumber");

        // Validation
        if (ValidationUtil.isNullOrEmpty(bookingIdStr) ||
                ValidationUtil.isNullOrEmpty(paymentMethod)) {
            request.setAttribute("errorMessage", "Please fill all required fields!");
            doGet(request, response);
            return;
        }

        // Conditional validation based on strategy
        if ("Credit Card".equals(paymentMethod) || "Debit Card".equals(paymentMethod)) {
            if (ValidationUtil.isNullOrEmpty(cardNumber) || ValidationUtil.isNullOrEmpty(cardHolderName)) {
                request.setAttribute("errorMessage", "Please provide card details!");
                doGet(request, response);
                return;
            }
            if (!ValidationUtil.isValidCardNumber(cardNumber)) {
                request.setAttribute("errorMessage", "Invalid card number!");
                doGet(request, response);
                return;
            }
        } else if ("PayPal".equals(paymentMethod)) {
            if (ValidationUtil.isNullOrEmpty(paypalEmail)) {
                request.setAttribute("errorMessage", "Please provide PayPal email!");
                doGet(request, response);
                return;
            }
        } else if ("Bank Transfer".equals(paymentMethod)) {
            if (ValidationUtil.isNullOrEmpty(bankName) || ValidationUtil.isNullOrEmpty(accountNumber)) {
                request.setAttribute("errorMessage", "Please provide bank details!");
                doGet(request, response);
                return;
            }
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        Booking booking = bookingDAO.getBookingById(bookingId);

        // Verify booking ownership
        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=unauthorized");
            return;
        }

        // Generate transaction ID
        String transactionId = "TXN" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Create payment using Strategy Pattern
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setUserId(userId);
        payment.setAmount(booking.getTotalAmount());
        payment.setPaymentMethod(paymentMethod);
        payment.setTransactionId(transactionId);
        payment.setPaymentStatus(AppConstants.PAYMENT_PENDING);

        // Create payment context
        PaymentContext context = new PaymentContext(payment);
        context.setCardHolderName(ValidationUtil.sanitizeInput(cardHolderName));
        context.setCardNumber(cardNumber);
        context.setExpiryDate(expiryDate);
        context.setCvv(cvv);
        context.setPaypalEmail(ValidationUtil.sanitizeInput(paypalEmail));
        context.setBankName(ValidationUtil.sanitizeInput(bankName));
        context.setAccountNumber(ValidationUtil.sanitizeInput(accountNumber));
        context.setPaymentMethod(paymentMethod);

        // Process payment using appropriate strategy
        PaymentStrategy strategy = PaymentStrategyFactory.createStrategy(paymentMethod);
        PaymentResult result = strategy.processPayment(context);

        if (!result.isSuccess()) {
            request.setAttribute("errorMessage", result.getErrorMessage());
            doGet(request, response);
            return;
        }

        // Update payment with processed result
        payment = result.getPayment();
        if (result.getTransactionId() != null) {
            payment.setTransactionId(result.getTransactionId());
        }

        int paymentId = paymentDAO.createPayment(payment);

        if (paymentId > 0) {
            response.sendRedirect(request.getContextPath() + "/viewPayments?success=created&transactionId=" + transactionId);
        } else {
            request.setAttribute("errorMessage", "Payment failed! Please try again.");
            doGet(request, response);
        }
    }
}