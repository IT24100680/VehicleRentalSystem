package com.vehiclerental.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // SQL Server Configuration
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=VehicleRentalDB;encrypt=true;trustServerCertificate=true";
    private static final String DB_USER = "sa"; // Change to your SQL Server username
    private static final String DB_PASSWORD = "123"; // Change to your SQL Server password
    private static final String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    // Connection Pool (Simple implementation)
    private static Connection connection = null;

    static {
        try {
            // Load SQL Server JDBC Driver
            Class.forName(DB_DRIVER);
            System.out.println("✅ SQL Server JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ SQL Server JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Get Database Connection
     */
    public static Connection getConnection() throws SQLException {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                System.out.println("✅ Database connected successfully!");
            }
            return connection;
        } catch (SQLException e) {
            System.err.println("❌ Failed to connect to database!");
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Close Database Connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✅ Database connection closed!");
            }
        } catch (SQLException e) {
            System.err.println("❌ Error closing database connection!");
            e.printStackTrace();
        }
    }

    /**
     * Test Database Connection
     */
    public static boolean testConnection() {
        try {
            Connection conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}