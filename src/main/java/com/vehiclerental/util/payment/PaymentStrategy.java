package com.vehiclerental.util.payment;

import com.vehiclerental.model.Payment;

public interface PaymentStrategy {
    /**
     * Execute payment-specific handling and return enriched Payment entity.
     */
    Payment process(Payment payment, PaymentContext context);
}


