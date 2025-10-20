package com.vehiclerental.strategy;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.ValidationUtil;

/**
 * Strategy Pattern for Card Payment Processing
 * Handles different types of card payments with specific validation and processing
 */
public class CardPaymentStrategy implements PaymentStrategy {
    
    @Override
    public PaymentResult processPayment(PaymentContext context) {
        PaymentResult result = new PaymentResult();
        
        // Validate card details
        if (!validateCardDetails(context)) {
            result.setSuccess(false);
            result.setErrorMessage("Invalid card details provided");
            return result;
        }
        
        // Process card payment
        Payment payment = context.getPayment();
        payment.setCardNumber(context.getCardNumber());
        payment.setCardHolderName(context.getCardHolderName());
        // Keep the original payment method from context
        // payment.setPaymentMethod("Card Payment");
        
        // Simulate card processing
        if (simulateCardProcessing(context)) {
            result.setSuccess(true);
            payment.setPaymentStatus("Approved");
            result.setPayment(payment);
            result.setTransactionId(generateTransactionId());
        } else {
            result.setSuccess(false);
            result.setErrorMessage("Card payment processing failed");
        }
        
        return result;
    }
    
    private boolean validateCardDetails(PaymentContext context) {
        // Validate card number
        if (!ValidationUtil.isValidCardNumber(context.getCardNumber())) {
            return false;
        }
        
        // Validate card holder name
        if (ValidationUtil.isNullOrEmpty(context.getCardHolderName())) {
            return false;
        }
        
        // Validate expiry date
        if (ValidationUtil.isNullOrEmpty(context.getExpiryDate())) {
            return false;
        }
        
        // Validate CVV
        if (ValidationUtil.isNullOrEmpty(context.getCvv()) || context.getCvv().length() != 3) {
            return false;
        }
        
        return true;
    }
    
    private boolean simulateCardProcessing(PaymentContext context) {
        // Simulate card processing logic
        // In real implementation, this would integrate with payment gateway
        String cardNumber = context.getCardNumber();
        
        // Simple validation: card number should not start with 0
        if (cardNumber.startsWith("0")) {
            return false;
        }
        
        // Simulate processing delay
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        return true;
    }
    
    private String generateTransactionId() {
        return "CARD_" + System.currentTimeMillis() + "_" + 
               (int)(Math.random() * 1000);
    }
}
