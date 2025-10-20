package com.vehiclerental.strategy;

import com.vehiclerental.model.Payment;

/**
 * Context class for Payment Strategy Pattern
 * Contains all necessary data for payment processing
 */
public class PaymentContext {
    private Payment payment;
    private String cardNumber;
    private String cardHolderName;
    private String expiryDate;
    private String cvv;
    private String paypalEmail;
    private String bankName;
    private String accountNumber;
    private String paymentMethod;
    
    // Constructors
    public PaymentContext() {}
    
    public PaymentContext(Payment payment) {
        this.payment = payment;
    }
    
    // Getters and Setters
    public Payment getPayment() {
        return payment;
    }
    
    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public String getCardNumber() {
        return cardNumber;
    }
    
    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }
    
    public String getCardHolderName() {
        return cardHolderName;
    }
    
    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }
    
    public String getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public String getCvv() {
        return cvv;
    }
    
    public void setCvv(String cvv) {
        this.cvv = cvv;
    }
    
    public String getPaypalEmail() {
        return paypalEmail;
    }
    
    public void setPaypalEmail(String paypalEmail) {
        this.paypalEmail = paypalEmail;
    }
    
    public String getBankName() {
        return bankName;
    }
    
    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}
