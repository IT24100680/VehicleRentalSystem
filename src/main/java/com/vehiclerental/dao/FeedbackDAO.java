package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.Feedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    /**
     * Add new feedback
     */
    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (user_id, booking_id, vehicle_id, rating, comments, is_anonymous) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, feedback.getUserId());
            pstmt.setInt(2, feedback.getBookingId());
            pstmt.setInt(3, feedback.getVehicleId());
            pstmt.setInt(4, feedback.getRating());
            pstmt.setString(5, feedback.getComments());
            pstmt.setBoolean(6, feedback.isAnonymous());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get feedback by ID
     */
    public Feedback getFeedbackById(int feedbackId) {
        String sql = "SELECT f.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Feedback f " +
                "INNER JOIN Users u ON f.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON f.vehicle_id = v.vehicle_id " +
                "WHERE f.feedback_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, feedbackId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractFeedbackFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get feedbacks by user ID
     */
    public List<Feedback> getFeedbacksByUserId(int userId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Feedback f " +
                "INNER JOIN Users u ON f.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON f.vehicle_id = v.vehicle_id " +
                "WHERE f.user_id = ? AND f.is_active = 1 ORDER BY f.feedback_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                feedbacks.add(extractFeedbackFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    /**
     * Get feedbacks by vehicle ID
     */
    public List<Feedback> getFeedbacksByVehicleId(int vehicleId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Feedback f " +
                "INNER JOIN Users u ON f.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON f.vehicle_id = v.vehicle_id " +
                "WHERE f.vehicle_id = ? AND f.is_active = 1 ORDER BY f.feedback_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, vehicleId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                feedbacks.add(extractFeedbackFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    /**
     * Get all feedbacks
     */
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as user_name, v.vehicle_name " +
                "FROM Feedback f " +
                "INNER JOIN Users u ON f.user_id = u.user_id " +
                "INNER JOIN Vehicles v ON f.vehicle_id = v.vehicle_id " +
                "WHERE f.is_active = 1 ORDER BY f.feedback_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                feedbacks.add(extractFeedbackFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    /**
     * Update feedback
     */
    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE Feedback SET rating = ?, comments = ?, is_anonymous = ?, updated_at = GETDATE() " +
                "WHERE feedback_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, feedback.getRating());
            pstmt.setString(2, feedback.getComments());
            pstmt.setBoolean(3, feedback.isAnonymous());
            pstmt.setInt(4, feedback.getFeedbackId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete feedback (soft delete)
     */
    public boolean deleteFeedback(int feedbackId) {
        String sql = "UPDATE Feedback SET is_active = 0, updated_at = GETDATE() WHERE feedback_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, feedbackId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get average rating for a vehicle
     */
    public double getAverageRating(int vehicleId) {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM Feedback WHERE vehicle_id = ? AND is_active = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, vehicleId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    /**
     * Get feedback count for a vehicle
     */
    public int getFeedbackCount(int vehicleId) {
        String sql = "SELECT COUNT(*) FROM Feedback WHERE vehicle_id = ? AND is_active = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, vehicleId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Extract Feedback object from ResultSet
     */
    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setBookingId(rs.getInt("booking_id"));
        feedback.setVehicleId(rs.getInt("vehicle_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComments(rs.getString("comments"));
        feedback.setAnonymous(rs.getBoolean("is_anonymous"));
        feedback.setFeedbackDate(rs.getTimestamp("feedback_date"));
        feedback.setActive(rs.getBoolean("is_active"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        feedback.setUserName(rs.getString("user_name"));
        feedback.setVehicleName(rs.getString("vehicle_name"));
        return feedback;
    }
}