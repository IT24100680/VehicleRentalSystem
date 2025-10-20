package com.vehiclerental.util;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DateUtil {

    private static final String DATE_FORMAT = "yyyy-MM-dd";
    private static final SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

    /**
     * Convert string to SQL Date
     */
    public static Date stringToSqlDate(String dateStr) {
        try {
            java.util.Date utilDate = sdf.parse(dateStr);
            return new Date(utilDate.getTime());
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Convert SQL Date to string
     */
    public static String sqlDateToString(Date sqlDate) {
        if (sqlDate == null) {
            return "";
        }
        return sdf.format(sqlDate);
    }

    /**
     * Calculate days between two dates
     */
    public static int calculateDaysBetween(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return 0;
        }

        LocalDate start = startDate.toLocalDate();
        LocalDate end = endDate.toLocalDate();

        return (int) ChronoUnit.DAYS.between(start, end);
    }

    /**
     * Get current SQL Date
     */
    public static Date getCurrentSqlDate() {
        return new Date(System.currentTimeMillis());
    }

    /**
     * Check if date is in the past (excluding today)
     */
    public static boolean isPastDate(Date date) {
        if (date == null) {
            return false;
        }
        // Allow today's date, only reject dates before today
        return date.before(getCurrentSqlDate());
    }

    /**
     * Check if date is in the future
     */
    public static boolean isFutureDate(Date date) {
        if (date == null) {
            return false;
        }
        return date.after(getCurrentSqlDate());
    }

    /**
     * Validate date range (allows same day)
     */
    public static boolean isValidDateRange(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return false;
        }
        // Allow same day bookings (endDate can be same as startDate)
        return !endDate.before(startDate);
    }

    /**
     * Format timestamp to readable string
     */
    public static String formatTimestamp(java.sql.Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return dateFormat.format(timestamp);
    }
}