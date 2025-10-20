package com.vehiclerental.strategy;

/**
 * Strategy Pattern Interface for Payment Processing
 * Defines the contract for different payment strategies
 */
public interface PaymentStrategy {
    PaymentResult processPayment(PaymentContext context);
}
