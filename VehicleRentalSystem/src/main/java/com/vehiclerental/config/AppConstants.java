package com.vehiclerental.config;

public class AppConstants {

    // Application Info
    public static final String APP_NAME = "Vehicle Rental System";
    public static final String APP_VERSION = "1.0.0";

    // User Roles
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_CUSTOMER = "CUSTOMER";

    // Session Attributes
    public static final String SESSION_USER = "loggedInUser";
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USER_ROLE = "userRole";
    public static final String SESSION_USER_NAME = "userName";
    public static final String SESSION_USER_EMAIL = "userEmail";

    // Booking Status
    public static final String BOOKING_PENDING = "Pending";
    public static final String BOOKING_APPROVED = "Approved";
    public static final String BOOKING_REJECTED = "Rejected";
    public static final String BOOKING_CANCELLED = "Cancelled";
    public static final String BOOKING_COMPLETED = "Completed";

    // Payment Status
    public static final String PAYMENT_PENDING = "Pending";
    public static final String PAYMENT_APPROVED = "Approved";
    public static final String PAYMENT_REJECTED = "Rejected";
    public static final String PAYMENT_REFUNDED = "Refunded";

    // Vehicle Status
    public static final String VEHICLE_AVAILABLE = "Available";
    public static final String VEHICLE_BOOKED = "Booked";
    public static final String VEHICLE_MAINTENANCE = "Maintenance";
    public static final String VEHICLE_UNAVAILABLE = "Unavailable";

    // Ticket Status
    public static final String TICKET_OPEN = "Open";
    public static final String TICKET_IN_PROGRESS = "In Progress";
    public static final String TICKET_RESOLVED = "Resolved";
    public static final String TICKET_CLOSED = "Closed";

    // Messages
    public static final String MSG_SUCCESS = "success";
    public static final String MSG_ERROR = "error";
    public static final String MSG_WARNING = "warning";
    public static final String MSG_INFO = "info";

    // Pagination
    public static final int RECORDS_PER_PAGE = 10;

    // File Upload
    public static final String UPLOAD_DIRECTORY = "assets/uploads/";
    public static final int MAX_FILE_SIZE = 1024 * 1024 * 5; // 5MB

    // Date Format
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    // Email Configuration (Optional)
    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final String SMTP_PORT = "587";
    public static final String SMTP_USERNAME = "your-email@gmail.com";
    public static final String SMTP_PASSWORD = "your-app-password";
}