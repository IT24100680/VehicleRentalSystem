package com.vehiclerental.strategy;

import com.vehiclerental.model.Payment;

/**
 * Result class for Payment Strategy Pattern
 * Contains the result of payment processing
 */
public class PaymentResult {
    private boolean success;
    private String errorMessage;
    private Payment payment;
    private String transactionId;
    private String processingTime;
    
    // Constructors
    public PaymentResult() {}
    
    public PaymentResult(boolean success) {
        this.success = success;
    }
    
    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    public Payment getPayment() {
        return payment;
    }
    
    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getProcessingTime() {
        return processingTime;
    }
    
    public void setProcessingTime(String processingTime) {
        this.processingTime = processingTime;
    }
}
