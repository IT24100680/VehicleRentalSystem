package com.vehiclerental.util.payment;

public class PaymentContext {
    private String cardHolderName;
    private String cardNumber;
    private String expiryDate;
    private String cvv;
    private String paypalEmail;
    private String bankName;
    private String accountNumber;

    public String getCardHolderName() { return cardHolderName; }
    public void setCardHolderName(String cardHolderName) { this.cardHolderName = cardHolderName; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }

    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }

    public String getCvv() { return cvv; }
    public void setCvv(String cvv) { this.cvv = cvv; }

    public String getPaypalEmail() { return paypalEmail; }
    public void setPaypalEmail(String paypalEmail) { this.paypalEmail = paypalEmail; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }
}


