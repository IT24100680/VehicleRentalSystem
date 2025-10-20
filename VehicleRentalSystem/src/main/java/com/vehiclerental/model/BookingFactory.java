package com.vehiclerental.model;

import java.math.BigDecimal;
import java.sql.Date;

public final class BookingFactory {

    private BookingFactory() {}

    public static Booking create(
            int userId,
            int vehicleId,
            Date startDate,
            Date endDate,
            String pickupLocation,
            String dropoffLocation,
            int totalDays,
            BigDecimal totalAmount,
            String specialRequests,
            String bookingStatus
    ) {
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setVehicleId(vehicleId);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setPickupLocation(pickupLocation);
        booking.setDropoffLocation(dropoffLocation);
        booking.setTotalDays(totalDays);
        booking.setTotalAmount(totalAmount);
        booking.setSpecialRequests(specialRequests);
        booking.setBookingStatus(bookingStatus);
        return booking;
    }
}


