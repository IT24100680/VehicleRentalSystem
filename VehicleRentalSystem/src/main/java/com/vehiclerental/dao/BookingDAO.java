package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /**
     * Create new booking
     */
    public int createBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (user_id, vehicle_id, start_date, end_date, pickup_location, " +
                "dropoff_location, total_days, total_amount, special_requests, booking_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getVehicleId());
            pstmt.setDate(3, booking.getStartDate());
            pstmt.setDate(4, booking.getEndDate());
            pstmt.setString(5, booking.getPickupLocation());
            pstmt.setString(6, booking.getDropoffLocation());
            pstmt.setInt(7, booking.getTotalDays());
            pstmt.setBigDecimal(8, booking.getTotalAmount());
            pstmt.setString(9, booking.getSpecialRequests());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Get booking by ID
     */
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Bookings b " +
                "INNER JOIN Users u ON b.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE b.booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBookingFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get bookings by user ID
     */
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Bookings b " +
                "INNER JOIN Users u ON b.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE b.user_id = ? ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get all bookings
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Bookings b " +
                "INNER JOIN Users u ON b.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get pending bookings
     */
    public List<Booking> getPendingBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Bookings b " +
                "INNER JOIN Users u ON b.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE b.booking_status = 'Pending' ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Update booking
     */
    public boolean updateBooking(Booking booking) {
        String sql = "UPDATE Bookings SET start_date = ?, end_date = ?, pickup_location = ?, " +
                "dropoff_location = ?, total_days = ?, total_amount = ?, special_requests = ?, " +
                "updated_at = GETDATE() WHERE booking_id = ? AND booking_status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, booking.getStartDate());
            pstmt.setDate(2, booking.getEndDate());
            pstmt.setString(3, booking.getPickupLocation());
            pstmt.setString(4, booking.getDropoffLocation());
            pstmt.setInt(5, booking.getTotalDays());
            pstmt.setBigDecimal(6, booking.getTotalAmount());
            pstmt.setString(7, booking.getSpecialRequests());
            pstmt.setInt(8, booking.getBookingId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update booking status (Admin)
     */
    public boolean updateBookingStatus(int bookingId, String status, String adminRemarks) {
        String sql = "UPDATE Bookings SET booking_status = ?, admin_remarks = ?, updated_at = GETDATE() WHERE booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, adminRemarks);
            pstmt.setInt(3, bookingId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete booking (only if pending)
     */
    public boolean deleteBooking(int bookingId) {
        String sql = "DELETE FROM Bookings WHERE booking_id = ? AND booking_status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookingId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total booking count
     */
    public int getTotalBookingCount() {
        String sql = "SELECT COUNT(*) FROM Bookings";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Extract Booking object from ResultSet
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setVehicleId(rs.getInt("vehicle_id"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setStartDate(rs.getDate("start_date"));
        booking.setEndDate(rs.getDate("end_date"));
        booking.setPickupLocation(rs.getString("pickup_location"));
        booking.setDropoffLocation(rs.getString("dropoff_location"));
        booking.setTotalDays(rs.getInt("total_days"));
        booking.setTotalAmount(rs.getBigDecimal("total_amount"));
        booking.setBookingStatus(rs.getString("booking_status"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setAdminRemarks(rs.getString("admin_remarks"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));
        booking.setUserName(rs.getString("user_name"));
        booking.setVehicleName(rs.getString("vehicle_name"));
        return booking;
    }
}