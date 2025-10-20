package com.vehiclerental.util.payment;

import com.vehiclerental.util.payment.strategies.BankTransferPaymentStrategy;
import com.vehiclerental.util.payment.strategies.CardPaymentStrategy;
import com.vehiclerental.util.payment.strategies.PayPalPaymentStrategy;

public final class PaymentStrategyFactory {

    private PaymentStrategyFactory() {}

    public static PaymentStrategy of(String method) {
        if (method == null) return new CardPaymentStrategy();
        switch (method) {
            case "Credit Card":
            case "Debit Card":
                return new CardPaymentStrategy();
            case "PayPal":
                return new PayPalPaymentStrategy();
            case "Bank Transfer":
                return new BankTransferPaymentStrategy();
            default:
                return new CardPaymentStrategy();
        }
    }
}


