package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /**
     * Create new payment
     */
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (booking_id, user_id, amount, payment_method, card_number, " +
                "card_holder_name, transaction_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, payment.getBookingId());
            pstmt.setInt(2, payment.getUserId());
            pstmt.setBigDecimal(3, payment.getAmount());
            pstmt.setString(4, payment.getPaymentMethod());
            pstmt.setString(5, payment.getCardNumber());
            pstmt.setString(6, payment.getCardHolderName());
            pstmt.setString(7, payment.getTransactionId());

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
     * Get payment by ID
     */
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE p.payment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, paymentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get payment by booking ID
     */
    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE p.booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get payments by user ID
     */
    public List<Payment> getPaymentsByUserId(int userId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE p.user_id = ? ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    /**
     * Get all payments
     */
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    /**
     * Get pending payments
     */
    public List<Payment> getPendingPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE p.payment_status = 'Pending' ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    /**
     * Get refund requests
     */
    public List<Payment> getRefundRequests() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Payments p " +
                "INNER JOIN Users u ON p.user_id = u.user_id " +
                "INNER JOIN Bookings b ON p.booking_id = b.booking_id " +
                "INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id " +
                "WHERE p.refund_requested = 1 AND p.refund_status = 'Pending' ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    /**
     * Update payment (only if pending)
     */
    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE Payments SET payment_method = ?, card_number = ?, card_holder_name = ?, " +
                "updated_at = GETDATE() WHERE payment_id = ? AND payment_status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, payment.getPaymentMethod());
            pstmt.setString(2, payment.getCardNumber());
            pstmt.setString(3, payment.getCardHolderName());
            pstmt.setInt(4, payment.getPaymentId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update payment status (Admin)
     */
    public boolean updatePaymentStatus(int paymentId, String status, String adminRemarks) {
        String sql = "UPDATE Payments SET payment_status = ?, admin_remarks = ?, updated_at = GETDATE() WHERE payment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, adminRemarks);
            pstmt.setInt(3, paymentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Request refund
     */
    public boolean requestRefund(int paymentId, String refundReason) {
        String sql = "UPDATE Payments SET refund_requested = 1, refund_reason = ?, refund_status = 'Pending', " +
                "updated_at = GETDATE() WHERE payment_id = ? AND payment_status = 'Approved'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, refundReason);
            pstmt.setInt(2, paymentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update refund status (Admin)
     */
    public boolean updateRefundStatus(int paymentId, String refundStatus, String adminRemarks) {
        String sql = "UPDATE Payments SET refund_status = ?, admin_remarks = ?, refund_date = GETDATE(), " +
                "updated_at = GETDATE() WHERE payment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, refundStatus);
            pstmt.setString(2, adminRemarks);
            pstmt.setInt(3, paymentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete payment (only if pending)
     */
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM Payments WHERE payment_id = ? AND payment_status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, paymentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total revenue
     */
    public double getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(amount), 0) FROM Payments WHERE payment_status = 'Approved'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    /**
     * Extract Payment object from ResultSet
     */
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setBookingId(rs.getInt("booking_id"));
        payment.setUserId(rs.getInt("user_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setCardNumber(rs.getString("card_number"));
        payment.setCardHolderName(rs.getString("card_holder_name"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setRefundRequested(rs.getBoolean("refund_requested"));
        payment.setRefundReason(rs.getString("refund_reason"));
        payment.setRefundStatus(rs.getString("refund_status"));
        payment.setRefundDate(rs.getTimestamp("refund_date"));
        payment.setAdminRemarks(rs.getString("admin_remarks"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        payment.setUpdatedAt(rs.getTimestamp("updated_at"));
        payment.setUserName(rs.getString("user_name"));
        payment.setVehicleName(rs.getString("vehicle_name"));
        return payment;
    }
}