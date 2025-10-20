package com.vehiclerental.util.payment.strategies;

import com.vehiclerental.model.Payment;
import com.vehiclerental.util.payment.PaymentContext;
import com.vehiclerental.util.payment.PaymentStrategy;

public class PayPalPaymentStrategy implements PaymentStrategy {
    @Override
    public Payment process(Payment payment, PaymentContext context) {
        // For demo: store PayPal email in cardHolderName field to avoid schema changes
        payment.setCardHolderName(context.getPaypalEmail());
        payment.setCardNumber(null);
        return payment;
    }
}


