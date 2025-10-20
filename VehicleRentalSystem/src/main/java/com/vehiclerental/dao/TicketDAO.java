package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.Ticket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    /**
     * Create new ticket
     */
    public boolean createTicket(Ticket ticket) {
        String sql = "INSERT INTO Tickets (user_id, category, subject, description, priority, ticket_status) " +
                "VALUES (?, ?, ?, ?, ?, 'Open')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ticket.getUserId());
            pstmt.setString(2, ticket.getCategory());
            pstmt.setString(3, ticket.getSubject());
            pstmt.setString(4, ticket.getDescription());
            pstmt.setString(5, ticket.getPriority());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get ticket by ID
     */
    public Ticket getTicketById(int ticketId) {
        String sql = "SELECT t.*, u.full_name as user_name, u.email as user_email " +
                "FROM Tickets t " +
                "INNER JOIN Users u ON t.user_id = u.user_id " +
                "WHERE t.ticket_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ticketId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractTicketFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get tickets by user ID
     */
    public List<Ticket> getTicketsByUserId(int userId) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.email as user_email " +
                "FROM Tickets t " +
                "INNER JOIN Users u ON t.user_id = u.user_id " +
                "WHERE t.user_id = ? ORDER BY t.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                tickets.add(extractTicketFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Get all tickets
     */
    public List<Ticket> getAllTickets() {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.email as user_email " +
                "FROM Tickets t " +
                "INNER JOIN Users u ON t.user_id = u.user_id " +
                "ORDER BY t.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                tickets.add(extractTicketFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Get open tickets
     */
    public List<Ticket> getOpenTickets() {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.email as user_email " +
                "FROM Tickets t " +
                "INNER JOIN Users u ON t.user_id = u.user_id " +
                "WHERE t.ticket_status IN ('Open', 'In Progress') ORDER BY t.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                tickets.add(extractTicketFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Update ticket
     */
    public boolean updateTicket(Ticket ticket) {
        String sql = "UPDATE Tickets SET category = ?, subject = ?, description = ?, priority = ?, " +
                "updated_at = GETDATE() WHERE ticket_id = ? AND ticket_status = 'Open'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ticket.getCategory());
            pstmt.setString(2, ticket.getSubject());
            pstmt.setString(3, ticket.getDescription());
            pstmt.setString(4, ticket.getPriority());
            pstmt.setInt(5, ticket.getTicketId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update ticket status (Admin)
     */
    public boolean updateTicketStatus(int ticketId, String status, String adminResponse) {
        String sql = "UPDATE Tickets SET ticket_status = ?, admin_response = ?, updated_at = GETDATE(), " +
                "resolved_at = CASE WHEN ? = 'Resolved' THEN GETDATE() ELSE resolved_at END " +
                "WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, adminResponse);
            pstmt.setString(3, status);
            pstmt.setInt(4, ticketId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete ticket
     */
    public boolean deleteTicket(int ticketId) {
        String sql = "DELETE FROM Tickets WHERE ticket_id = ? AND ticket_status = 'Open'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ticketId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total ticket count
     */
    public int getTotalTicketCount() {
        String sql = "SELECT COUNT(*) FROM Tickets";

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
     * Get open ticket count
     */
    public int getOpenTicketCount() {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE ticket_status IN ('Open', 'In Progress')";

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
     * Extract Ticket object from ResultSet
     */
    private Ticket extractTicketFromResultSet(ResultSet rs) throws SQLException {
        Ticket ticket = new Ticket();
        ticket.setTicketId(rs.getInt("ticket_id"));
        ticket.setUserId(rs.getInt("user_id"));
        ticket.setCategory(rs.getString("category"));
        ticket.setSubject(rs.getString("subject"));
        ticket.setDescription(rs.getString("description"));
        ticket.setPriority(rs.getString("priority"));
        ticket.setTicketStatus(rs.getString("ticket_status"));
        ticket.setAdminResponse(rs.getString("admin_response"));
        ticket.setCreatedAt(rs.getTimestamp("created_at"));
        ticket.setUpdatedAt(rs.getTimestamp("updated_at"));
        ticket.setResolvedAt(rs.getTimestamp("resolved_at"));
        ticket.setUserName(rs.getString("user_name"));
        ticket.setUserEmail(rs.getString("user_email"));
        return ticket;
    }
}