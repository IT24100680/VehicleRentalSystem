package com.vehiclerental.strategy;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.ValidationUtil;

/**
 * PayPal Payment Strategy Implementation
 * Handles PayPal payment processing
 */
public class PayPalPaymentStrategy implements PaymentStrategy {
    
    @Override
    public PaymentResult processPayment(PaymentContext context) {
        PaymentResult result = new PaymentResult();
        
        // Validate PayPal details
        if (!validatePayPalDetails(context)) {
            result.setSuccess(false);
            result.setErrorMessage("Invalid PayPal details provided");
            return result;
        }
        
        // Process PayPal payment
        Payment payment = context.getPayment();
        payment.setCardHolderName(context.getPaypalEmail()); // Store email in card holder field
        payment.setCardNumber(null); // No card number for PayPal
        payment.setPaymentMethod("PayPal");
        
        // Simulate PayPal processing
        if (simulatePayPalProcessing(context)) {
            result.setSuccess(true);
            result.setPayment(payment);
            result.setTransactionId(generatePayPalTransactionId());
        } else {
            result.setSuccess(false);
            result.setErrorMessage("PayPal payment processing failed");
        }
        
        return result;
    }
    
    private boolean validatePayPalDetails(PaymentContext context) {
        // Validate PayPal email
        if (ValidationUtil.isNullOrEmpty(context.getPaypalEmail())) {
            return false;
        }
        
        // Basic email validation
        if (!context.getPaypalEmail().contains("@")) {
            return false;
        }
        
        return true;
    }
    
    private boolean simulatePayPalProcessing(PaymentContext context) {
        // Simulate PayPal processing logic
        // In real implementation, this would integrate with PayPal API
        
        // Simulate processing delay
        try {
            Thread.sleep(200);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        return true;
    }
    
    private String generatePayPalTransactionId() {
        return "PP_" + System.currentTimeMillis() + "_" + 
               (int)(Math.random() * 1000);
    }
}
