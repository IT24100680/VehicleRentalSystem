package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /**
     * Register new user
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (full_name, email, phone, password_hash, role, address, city, state, zip_code, license_number, date_of_birth) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getPasswordHash());
            pstmt.setString(5, user.getRole());
            pstmt.setString(6, user.getAddress());
            pstmt.setString(7, user.getCity());
            pstmt.setString(8, user.getState());
            pstmt.setString(9, user.getZipCode());
            pstmt.setString(10, user.getLicenseNumber());
            pstmt.setDate(11, user.getDateOfBirth());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Login user
     */
    public User loginUser(String email, String passwordHash) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ? AND is_active = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, passwordHash);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get user by ID
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get user by email
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    /**
     * Get all customers
     */
    public List<User> getAllCustomers() {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'CUSTOMER' ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                customers.add(extractUserFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    /**
     * Update user profile
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET full_name = ?, phone = ?, address = ?, city = ?, state = ?, " +
                "zip_code = ?, license_number = ?, date_of_birth = ?, updated_at = GETDATE() " +
                "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getAddress());
            pstmt.setString(4, user.getCity());
            pstmt.setString(5, user.getState());
            pstmt.setString(6, user.getZipCode());
            pstmt.setString(7, user.getLicenseNumber());
            pstmt.setDate(8, user.getDateOfBirth());
            pstmt.setInt(9, user.getUserId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Change password
     */
    public boolean changePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET password_hash = ?, updated_at = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newPasswordHash);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deactivate user account
     */
    public boolean deactivateUser(int userId) {
        String sql = "UPDATE Users SET is_active = 0, updated_at = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Activate user account
     */
    public boolean activateUser(int userId) {
        String sql = "UPDATE Users SET is_active = 1, updated_at = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete user (Admin only)
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if email exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get total user count
     */
    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM Users WHERE is_active = 1";

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
     * Extract User object from ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setAddress(rs.getString("address"));
        user.setCity(rs.getString("city"));
        user.setState(rs.getString("state"));
        user.setZipCode(rs.getString("zip_code"));
        user.setLicenseNumber(rs.getString("license_number"));
        user.setDateOfBirth(rs.getDate("date_of_birth"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
}