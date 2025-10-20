-- FILE: src/main/resources/sql/create_database.sql

-- Create Database
CREATE DATABASE VehicleRentalDB;
GO

USE VehicleRentalDB;
GO

-- ============================================
-- TABLE: Users
-- ============================================
CREATE TABLE Users (
                       user_id INT PRIMARY KEY IDENTITY(1,1),
                       full_name NVARCHAR(100) NOT NULL,
                       email NVARCHAR(100) UNIQUE NOT NULL,
                       phone NVARCHAR(15),
                       password_hash NVARCHAR(255) NOT NULL,
                       role NVARCHAR(20) DEFAULT 'CUSTOMER' CHECK (role IN ('CUSTOMER', 'ADMIN')),
                       address NVARCHAR(255),
                       city NVARCHAR(50),
                       state NVARCHAR(50),
                       zip_code NVARCHAR(10),
                       license_number NVARCHAR(50),
                       date_of_birth DATE,
                       is_active BIT DEFAULT 1,
                       created_at DATETIME DEFAULT GETDATE(),
                       updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Vehicles
-- ============================================
CREATE TABLE Vehicles (
                          vehicle_id INT PRIMARY KEY IDENTITY(1,1),
                          vehicle_name NVARCHAR(100) NOT NULL,
                          brand NVARCHAR(50) NOT NULL,
                          model NVARCHAR(50) NOT NULL,
                          year INT,
                          category NVARCHAR(50) CHECK (category IN ('Sedan', 'SUV', 'Hatchback', 'Luxury', 'Van', 'Truck')),
                          fuel_type NVARCHAR(20) CHECK (fuel_type IN ('Petrol', 'Diesel', 'Electric', 'Hybrid')),
                          transmission NVARCHAR(20) CHECK (transmission IN ('Manual', 'Automatic')),
                          seating_capacity INT,
                          price_per_day DECIMAL(10,2) NOT NULL,
                          vehicle_number NVARCHAR(20) UNIQUE,
                          color NVARCHAR(30),
                          image_url NVARCHAR(255),
                          features NVARCHAR(MAX),
                          availability_status NVARCHAR(20) DEFAULT 'Available' CHECK (availability_status IN ('Available', 'Booked', 'Maintenance', 'Unavailable')),
                          is_active BIT DEFAULT 1,
                          created_at DATETIME DEFAULT GETDATE(),
                          updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Bookings
-- ============================================
CREATE TABLE Bookings (
                          booking_id INT PRIMARY KEY IDENTITY(1,1),
                          user_id INT FOREIGN KEY REFERENCES Users(user_id),
                          vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
                          booking_date DATETIME DEFAULT GETDATE(),
                          start_date DATE NOT NULL,
                          end_date DATE NOT NULL,
                          pickup_location NVARCHAR(255),
                          dropoff_location NVARCHAR(255),
                          total_days INT,
                          total_amount DECIMAL(10,2),
                          booking_status NVARCHAR(20) DEFAULT 'Pending' CHECK (booking_status IN ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed')),
                          special_requests NVARCHAR(MAX),
                          admin_remarks NVARCHAR(MAX),
                          created_at DATETIME DEFAULT GETDATE(),
                          updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Payments
-- ============================================
CREATE TABLE Payments (
                          payment_id INT PRIMARY KEY IDENTITY(1,1),
                          booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id),
                          user_id INT FOREIGN KEY REFERENCES Users(user_id),
                          amount DECIMAL(10,2) NOT NULL,
                          payment_method NVARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer')),
                          card_number NVARCHAR(20),
                          card_holder_name NVARCHAR(100),
                          transaction_id NVARCHAR(100) UNIQUE,
                          payment_status NVARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Approved', 'Rejected', 'Refunded')),
                          payment_date DATETIME DEFAULT GETDATE(),
                          refund_requested BIT DEFAULT 0,
                          refund_reason NVARCHAR(MAX),
                          refund_status NVARCHAR(20) CHECK (refund_status IN ('Pending', 'Approved', 'Rejected', NULL)),
                          refund_date DATETIME,
                          admin_remarks NVARCHAR(MAX),
                          created_at DATETIME DEFAULT GETDATE(),
                          updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Feedback
-- ============================================
CREATE TABLE Feedback (
                          feedback_id INT PRIMARY KEY IDENTITY(1,1),
                          user_id INT FOREIGN KEY REFERENCES Users(user_id),
                          booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id),
                          vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
                          rating INT CHECK (rating BETWEEN 1 AND 5),
                          comments NVARCHAR(MAX),
                          is_anonymous BIT DEFAULT 0,
                          feedback_date DATETIME DEFAULT GETDATE(),
                          is_active BIT DEFAULT 1,
                          created_at DATETIME DEFAULT GETDATE(),
                          updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Tickets (Support/Service)
-- ============================================
CREATE TABLE Tickets (
                         ticket_id INT PRIMARY KEY IDENTITY(1,1),
                         user_id INT FOREIGN KEY REFERENCES Users(user_id),
                         category NVARCHAR(50) CHECK (category IN ('Booking Issue', 'Payment Issue', 'Vehicle Issue', 'Technical Support', 'General Inquiry', 'Complaint', 'Other')),
                         subject NVARCHAR(200) NOT NULL,
                         description NVARCHAR(MAX) NOT NULL,
                         priority NVARCHAR(20) DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')),
                         ticket_status NVARCHAR(20) DEFAULT 'Open' CHECK (ticket_status IN ('Open', 'In Progress', 'Resolved', 'Closed')),
                         admin_response NVARCHAR(MAX),
                         created_at DATETIME DEFAULT GETDATE(),
                         updated_at DATETIME DEFAULT GETDATE(),
                         resolved_at DATETIME
);

-- ============================================
-- INDEXES for Performance
-- ============================================
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_bookings_user ON Bookings(user_id);
CREATE INDEX idx_bookings_vehicle ON Bookings(vehicle_id);
CREATE INDEX idx_payments_booking ON Payments(booking_id);
CREATE INDEX idx_feedback_vehicle ON Feedback(vehicle_id);
CREATE INDEX idx_tickets_user ON Tickets(user_id);

GO