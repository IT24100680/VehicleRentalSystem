package com.vehiclerental.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // Phone validation pattern (10 digits)
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9]{10}$");

    // Password validation pattern (min 8 chars, at least 1 letter and 1 number)
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$");

    // License number pattern
    private static final Pattern LICENSE_PATTERN =
            Pattern.compile("^[A-Z0-9]{8,15}$");

    // Card number pattern (16 digits)
    private static final Pattern CARD_NUMBER_PATTERN =
            Pattern.compile("^[0-9]{16}$");

    /**
     * Validate email
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validate phone number
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Validate password
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * Validate license number
     */
    public static boolean isValidLicense(String license) {
        if (license == null || license.trim().isEmpty()) {
            return false;
        }
        return LICENSE_PATTERN.matcher(license.trim().toUpperCase()).matches();
    }

    /**
     * Validate card number
     */
    public static boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return false;
        }
        return CARD_NUMBER_PATTERN.matcher(cardNumber.replaceAll("\\s", "")).matches();
    }

    /**
     * Check if string is null or empty
     */
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Validate rating (1-5)
     */
    public static boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    /**
     * Sanitize input (prevent XSS)
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;")
                .replaceAll("/", "&#x2F;");
    }

    /**
     * Validate numeric input
     */
    public static boolean isNumeric(String str) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate positive number
     */
    public static boolean isPositiveNumber(String str) {
        if (!isNumeric(str)) {
            return false;
        }
        return Double.parseDouble(str) > 0;
    }
}