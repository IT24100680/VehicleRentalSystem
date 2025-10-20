package com.vehiclerental.factory;

import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Vehicle;
import java.math.BigDecimal;
import java.sql.Date;

/**
 * Factory Pattern for creating different types of rental bookings
 * Handles creation of bookings based on vehicle category and rental duration
 */
public class RentalBookingFactory {
    
    private RentalBookingFactory() {}
    
    /**
     * Creates a booking based on vehicle category and rental type
     */
    public static Booking createRentalBooking(
            int userId,
            Vehicle vehicle,
            Date startDate,
            Date endDate,
            String pickupLocation,
            String dropoffLocation,
            String specialRequests,
            String bookingStatus) {
        
        // Calculate rental duration
        int totalDays = calculateRentalDays(startDate, endDate);
        BigDecimal totalAmount = calculateTotalAmount(vehicle, totalDays);
        
        // Create base booking
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setVehicleId(vehicle.getVehicleId());
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setPickupLocation(pickupLocation);
        booking.setDropoffLocation(dropoffLocation);
        booking.setTotalDays(totalDays);
        booking.setTotalAmount(totalAmount);
        booking.setSpecialRequests(specialRequests);
        booking.setBookingStatus(bookingStatus);
        
        // Apply category-specific logic
        applyCategorySpecificLogic(booking, vehicle);
        
        return booking;
    }
    
    /**
     * Creates a standard rental booking
     */
    public static Booking createStandardRental(
            int userId,
            Vehicle vehicle,
            Date startDate,
            Date endDate,
            String pickupLocation,
            String dropoffLocation,
            String specialRequests) {
        
        return createRentalBooking(userId, vehicle, startDate, endDate, 
                pickupLocation, dropoffLocation, specialRequests, "Pending");
    }
    
    /**
     * Creates a premium rental booking with additional services
     */
    public static Booking createPremiumRental(
            int userId,
            Vehicle vehicle,
            Date startDate,
            Date endDate,
            String pickupLocation,
            String dropoffLocation,
            String specialRequests) {
        
        Booking booking = createRentalBooking(userId, vehicle, startDate, endDate, 
                pickupLocation, dropoffLocation, specialRequests, "Pending");
        
        // Add premium service markup
        BigDecimal premiumMarkup = booking.getTotalAmount().multiply(new BigDecimal("0.15"));
        booking.setTotalAmount(booking.getTotalAmount().add(premiumMarkup));
        
        return booking;
    }
    
    /**
     * Creates a long-term rental booking with discount
     */
    public static Booking createLongTermRental(
            int userId,
            Vehicle vehicle,
            Date startDate,
            Date endDate,
            String pickupLocation,
            String dropoffLocation,
            String specialRequests) {
        
        Booking booking = createRentalBooking(userId, vehicle, startDate, endDate, 
                pickupLocation, dropoffLocation, specialRequests, "Pending");
        
        // Apply long-term discount (7+ days get 10% discount)
        if (booking.getTotalDays() >= 7) {
            BigDecimal discount = booking.getTotalAmount().multiply(new BigDecimal("0.10"));
            booking.setTotalAmount(booking.getTotalAmount().subtract(discount));
        }
        
        return booking;
    }
    
    private static int calculateRentalDays(Date startDate, Date endDate) {
        long diffTime = endDate.getTime() - startDate.getTime();
        int days = (int) (diffTime / (1000 * 60 * 60 * 24));
        return Math.max(1, days + 1); // Minimum 1 day
    }
    
    private static BigDecimal calculateTotalAmount(Vehicle vehicle, int totalDays) {
        return vehicle.getPricePerDay().multiply(new BigDecimal(totalDays));
    }
    
    private static void applyCategorySpecificLogic(Booking booking, Vehicle vehicle) {
        // Apply category-specific business rules
        switch (vehicle.getCategory().toLowerCase()) {
            case "luxury":
                // Luxury vehicles require additional security deposit
                booking.setSpecialRequests(
                    (booking.getSpecialRequests() != null ? booking.getSpecialRequests() + "; " : "") +
                    "Luxury vehicle - Additional security deposit required"
                );
                break;
            case "suv":
                // SUVs have different pickup requirements
                booking.setSpecialRequests(
                    (booking.getSpecialRequests() != null ? booking.getSpecialRequests() + "; " : "") +
                    "SUV - Special pickup arrangements available"
                );
                break;
            case "economy":
                // Economy vehicles have standard terms
                booking.setSpecialRequests(
                    (booking.getSpecialRequests() != null ? booking.getSpecialRequests() + "; " : "") +
                    "Economy vehicle - Standard rental terms"
                );
                break;
        }
    }
}
