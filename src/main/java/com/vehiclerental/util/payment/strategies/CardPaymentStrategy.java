package com.vehiclerental.util.payment.strategies;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.payment.PaymentContext;
import com.vehiclerental.util.payment.PaymentStrategy;

public class CardPaymentStrategy implements PaymentStrategy {
    @Override
    public Payment process(Payment payment, PaymentContext context) {
        payment.setCardHolderName(context.getCardHolderName());
        payment.setCardNumber(context.getCardNumber());
        // expiry and cvv are validated but not stored in DB in this app
        return payment;
    }
}


