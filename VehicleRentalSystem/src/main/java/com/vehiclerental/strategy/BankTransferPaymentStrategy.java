package com.vehiclerental.strategy;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.ValidationUtil;

/**
 * Bank Transfer Payment Strategy Implementation
 * Handles bank transfer payment processing
 */
public class BankTransferPaymentStrategy implements PaymentStrategy {
    
    @Override
    public PaymentResult processPayment(PaymentContext context) {
        PaymentResult result = new PaymentResult();
        
        // Validate bank details
        if (!validateBankDetails(context)) {
            result.setSuccess(false);
            result.setErrorMessage("Invalid bank details provided");
            return result;
        }
        
        // Process bank transfer
        Payment payment = context.getPayment();
        payment.setCardHolderName(context.getBankName()); // Store bank name
        payment.setCardNumber(context.getAccountNumber()); // Store account number
        payment.setPaymentMethod("Bank Transfer");
        
        // Simulate bank transfer processing
        if (simulateBankTransferProcessing(context)) {
            result.setSuccess(true);
            payment.setPaymentStatus("Approved");
            result.setPayment(payment);
            result.setTransactionId(generateBankTransferTransactionId());
        } else {
            result.setSuccess(false);
            result.setErrorMessage("Bank transfer processing failed");
        }
        
        return result;
    }
    
    private boolean validateBankDetails(PaymentContext context) {
        // Validate bank name
        if (ValidationUtil.isNullOrEmpty(context.getBankName())) {
            return false;
        }
        
        // Validate account number
        if (ValidationUtil.isNullOrEmpty(context.getAccountNumber())) {
            return false;
        }
        
        // Basic account number validation (should be numeric)
        try {
            Long.parseLong(context.getAccountNumber());
        } catch (NumberFormatException e) {
            return false;
        }
        
        return true;
    }
    
    private boolean simulateBankTransferProcessing(PaymentContext context) {
        // Simulate bank transfer processing logic
        // In real implementation, this would integrate with banking API
        
        // Simulate processing delay
        try {
            Thread.sleep(300);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        return true;
    }
    
    private String generateBankTransferTransactionId() {
        return "BT_" + System.currentTimeMillis() + "_" + 
               (int)(Math.random() * 1000);
    }
}
