package com.vehiclerental.dao;

import com.vehiclerental.config.DBConnection;
import com.vehiclerental.model.Vehicle;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    /**
     * Add new vehicle
     */
    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO Vehicles (vehicle_name, brand, model, year, category, fuel_type, transmission, " +
                "seating_capacity, price_per_day, vehicle_number, color, image_url, features, availability_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, vehicle.getVehicleName());
            pstmt.setString(2, vehicle.getBrand());
            pstmt.setString(3, vehicle.getModel());
            pstmt.setInt(4, vehicle.getYear());
            pstmt.setString(5, vehicle.getCategory());
            pstmt.setString(6, vehicle.getFuelType());
            pstmt.setString(7, vehicle.getTransmission());
            pstmt.setInt(8, vehicle.getSeatingCapacity());
            pstmt.setBigDecimal(9, vehicle.getPricePerDay());
            pstmt.setString(10, vehicle.getVehicleNumber());
            pstmt.setString(11, vehicle.getColor());
            pstmt.setString(12, vehicle.getImageUrl());
            pstmt.setString(13, vehicle.getFeatures());
            pstmt.setString(14, vehicle.getAvailabilityStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get vehicle by ID
     */
    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT * FROM Vehicles WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, vehicleId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractVehicleFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get all vehicles
     */
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles WHERE is_active = 1 ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                vehicles.add(extractVehicleFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    /**
     * Get available vehicles
     */
    public List<Vehicle> getAvailableVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles WHERE is_active = 1 AND availability_status = 'Available' ORDER BY price_per_day";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                vehicles.add(extractVehicleFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    /**
     * Get vehicles by category
     */
    public List<Vehicle> getVehiclesByCategory(String category) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles WHERE is_active = 1 AND category = ? AND availability_status = 'Available'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                vehicles.add(extractVehicleFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    /**
     * Update vehicle
     */
    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE Vehicles SET vehicle_name = ?, brand = ?, model = ?, year = ?, category = ?, " +
                "fuel_type = ?, transmission = ?, seating_capacity = ?, price_per_day = ?, vehicle_number = ?, " +
                "color = ?, image_url = ?, features = ?, availability_status = ?, updated_at = GETDATE() " +
                "WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, vehicle.getVehicleName());
            pstmt.setString(2, vehicle.getBrand());
            pstmt.setString(3, vehicle.getModel());
            pstmt.setInt(4, vehicle.getYear());
            pstmt.setString(5, vehicle.getCategory());
            pstmt.setString(6, vehicle.getFuelType());
            pstmt.setString(7, vehicle.getTransmission());
            pstmt.setInt(8, vehicle.getSeatingCapacity());
            pstmt.setBigDecimal(9, vehicle.getPricePerDay());
            pstmt.setString(10, vehicle.getVehicleNumber());
            pstmt.setString(11, vehicle.getColor());
            pstmt.setString(12, vehicle.getImageUrl());
            pstmt.setString(13, vehicle.getFeatures());
            pstmt.setString(14, vehicle.getAvailabilityStatus());
            pstmt.setInt(15, vehicle.getVehicleId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update vehicle availability status
     */
    public boolean updateVehicleStatus(int vehicleId, String status) {
        String sql = "UPDATE Vehicles SET availability_status = ?, updated_at = GETDATE() WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, vehicleId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete vehicle
     */
    public boolean deleteVehicle(int vehicleId) {
        String sql = "UPDATE Vehicles SET is_active = 0, updated_at = GETDATE() WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, vehicleId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total vehicle count
     */
    public int getTotalVehicleCount() {
        String sql = "SELECT COUNT(*) FROM Vehicles WHERE is_active = 1";

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
     * Get available vehicle count
     */
    public int getAvailableVehicleCount() {
        String sql = "SELECT COUNT(*) FROM Vehicles WHERE is_active = 1 AND availability_status = 'Available'";

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
     * Extract Vehicle object from ResultSet
     */
    private Vehicle extractVehicleFromResultSet(ResultSet rs) throws SQLException {
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(rs.getInt("vehicle_id"));
        vehicle.setVehicleName(rs.getString("vehicle_name"));
        vehicle.setBrand(rs.getString("brand"));
        vehicle.setModel(rs.getString("model"));
        vehicle.setYear(rs.getInt("year"));
        vehicle.setCategory(rs.getString("category"));
        vehicle.setFuelType(rs.getString("fuel_type"));
        vehicle.setTransmission(rs.getString("transmission"));
        vehicle.setSeatingCapacity(rs.getInt("seating_capacity"));
        vehicle.setPricePerDay(rs.getBigDecimal("price_per_day"));
        vehicle.setVehicleNumber(rs.getString("vehicle_number"));
        vehicle.setColor(rs.getString("color"));
        vehicle.setImageUrl(rs.getString("image_url"));
        vehicle.setFeatures(rs.getString("features"));
        vehicle.setAvailabilityStatus(rs.getString("availability_status"));
        vehicle.setActive(rs.getBoolean("is_active"));
        vehicle.setCreatedAt(rs.getTimestamp("created_at"));
        vehicle.setUpdatedAt(rs.getTimestamp("updated_at"));
        return vehicle;
    }
}