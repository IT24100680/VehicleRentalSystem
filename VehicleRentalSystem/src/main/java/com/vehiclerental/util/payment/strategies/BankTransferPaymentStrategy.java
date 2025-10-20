package com.vehiclerental.util.payment.strategies;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.payment.PaymentContext;
import com.vehiclerental.util.payment.PaymentStrategy;

public class BankTransferPaymentStrategy implements PaymentStrategy {
    @Override
    public Payment process(Payment payment, PaymentContext context) {
        // For demo: concatenate bank details into transactionId suffix for traceability
        String existingRef = payment.getTransactionId();
        String bankInfo = "-BANK:" + context.getBankName();
        payment.setTransactionId(existingRef != null ? existingRef + bankInfo : bankInfo);
        payment.setCardNumber(null);
        payment.setCardHolderName(null);
        return payment;
    }
}


