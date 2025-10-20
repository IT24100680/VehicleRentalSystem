package com.vehiclerental.strategy;

/**
 * Factory Pattern for Payment Strategies
 * Creates appropriate payment strategy based on payment method
 */
public class PaymentStrategyFactory {
    
    private PaymentStrategyFactory() {}
    
    /**
     * Creates payment strategy based on payment method
     */
    public static PaymentStrategy createStrategy(String paymentMethod) {
        if (paymentMethod == null) {
            return new CardPaymentStrategy();
        }
        
        switch (paymentMethod.toLowerCase()) {
            case "credit card":
            case "debit card":
            case "card":
                return new CardPaymentStrategy();
            case "paypal":
                return new PayPalPaymentStrategy();
            case "bank transfer":
            case "bank":
                return new BankTransferPaymentStrategy();
            default:
                return new CardPaymentStrategy();
        }
    }
    
    /**
     * Gets all available payment methods
     */
    public static String[] getAvailablePaymentMethods() {
        return new String[]{"Credit Card", "Debit Card", "PayPal", "Bank Transfer"};
    }
}
