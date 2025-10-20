-- ============================================
-- UPDATED DATABASE SCHEMA FOR ASSIGNMENT REQUIREMENTS
-- Based on EER Diagram Requirements
-- ============================================

-- Create Database
CREATE DATABASE VehicleRentalDB;
GO

USE VehicleRentalDB;
GO

-- ============================================
-- TABLE: VehicleType (New - Required by EER)
-- ============================================
CREATE TABLE VehicleType (
    type_id INT PRIMARY KEY IDENTITY(1,1),
    type_name NVARCHAR(50) NOT NULL UNIQUE,
    base_rate DECIMAL(10,2) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Users (Updated to match EER requirements)
-- ============================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(15),
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) DEFAULT 'CUSTOMER' CHECK (role IN ('CUSTOMER', 'ADMIN')),
    -- Address as composite attribute (Street, City, PostalCode)
    street NVARCHAR(100),
    city NVARCHAR(50),
    postal_code NVARCHAR(10),
    -- Additional EER attributes
    date_of_birth DATE,
    nic NVARCHAR(20) UNIQUE, -- National Identity Card
    license_number NVARCHAR(50),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: UserEmails (Multivalued attribute)
-- ============================================
CREATE TABLE UserEmails (
    email_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
    email NVARCHAR(100) NOT NULL,
    is_primary BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: UserPhones (Multivalued attribute)
-- ============================================
CREATE TABLE UserPhones (
    phone_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
    phone NVARCHAR(15) NOT NULL,
    phone_type NVARCHAR(20) DEFAULT 'Mobile' CHECK (phone_type IN ('Mobile', 'Home', 'Work')),
    is_primary BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Vehicles (Updated to match EER requirements)
-- ============================================
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    reg_no NVARCHAR(20) UNIQUE NOT NULL, -- Registration Number (EER requirement)
    make NVARCHAR(50) NOT NULL,
    model NVARCHAR(50) NOT NULL,
    year INT,
    daily_rate DECIMAL(10,2) NOT NULL, -- Daily Rate (EER requirement)
    vehicle_type_id INT FOREIGN KEY REFERENCES VehicleType(type_id), -- FK to VehicleType
    status NVARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Booked', 'Maintenance', 'Unavailable')),
    -- Additional attributes for web app compatibility
    vehicle_name NVARCHAR(100),
    fuel_type NVARCHAR(20) CHECK (fuel_type IN ('Petrol', 'Diesel', 'Electric', 'Hybrid')),
    transmission NVARCHAR(20) CHECK (transmission IN ('Manual', 'Automatic')),
    seating_capacity INT,
    color NVARCHAR(30),
    image_url NVARCHAR(255),
    features NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Car (Vehicle Specialization)
-- ============================================
CREATE TABLE Car (
    vehicle_id INT PRIMARY KEY FOREIGN KEY REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    trunk_size DECIMAL(5,2), -- Trunk size in cubic feet
    car_type NVARCHAR(30) CHECK (car_type IN ('Sedan', 'Hatchback', 'Coupe', 'Convertible'))
);

-- ============================================
-- TABLE: Van (Vehicle Specialization)
-- ============================================
CREATE TABLE Van (
    vehicle_id INT PRIMARY KEY FOREIGN KEY REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    capacity INT, -- Passenger capacity
    cargo_space DECIMAL(8,2), -- Cargo space in cubic feet
    van_type NVARCHAR(30) CHECK (van_type IN ('Passenger', 'Cargo', 'Mixed'))
);

-- ============================================
-- TABLE: Bike (Vehicle Specialization)
-- ============================================
CREATE TABLE Bike (
    vehicle_id INT PRIMARY KEY FOREIGN KEY REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    engine_cc INT, -- Engine displacement in cubic centimeters
    bike_type NVARCHAR(30) CHECK (bike_type IN ('Sport', 'Cruiser', 'Touring', 'Off-road'))
);

-- ============================================
-- TABLE: Driver (New - Required by EER)
-- ============================================
CREATE TABLE Driver (
    driver_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    license_no NVARCHAR(50) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.0 CHECK (rating BETWEEN 0.0 AND 5.0),
    availability BIT DEFAULT 1,
    phone NVARCHAR(15),
    email NVARCHAR(100),
    address NVARCHAR(255),
    hire_date DATE DEFAULT GETDATE(),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Bookings (Updated to match EER requirements)
-- ============================================
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
    driver_id INT FOREIGN KEY REFERENCES Driver(driver_id), -- Driver assignment
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    pickup_location NVARCHAR(255),
    dropoff_location NVARCHAR(255),
    total_cost DECIMAL(10,2), -- Total Cost (EER requirement)
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed')),
    -- Additional attributes for web app compatibility
    booking_date DATETIME DEFAULT GETDATE(),
    total_days INT,
    special_requests NVARCHAR(MAX),
    admin_remarks NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Payments (Updated to match EER requirements)
-- ============================================
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    amount DECIMAL(10,2) NOT NULL,
    method NVARCHAR(50) CHECK (method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash')), -- Method (EER requirement)
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Refunded')),
    transaction_ref NVARCHAR(100) UNIQUE, -- Transaction Reference (EER requirement)
    payment_date DATETIME DEFAULT GETDATE(),
    -- Additional attributes for web app compatibility
    card_number NVARCHAR(20),
    card_holder_name NVARCHAR(100),
    transaction_id NVARCHAR(100),
    refund_requested BIT DEFAULT 0,
    refund_reason NVARCHAR(MAX),
    refund_status NVARCHAR(20) CHECK (refund_status IN ('Pending', 'Approved', 'Rejected', NULL)),
    refund_date DATETIME,
    admin_remarks NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Feedback (Updated to match EER requirements)
-- ============================================
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
    rating INT CHECK (rating BETWEEN 1 AND 5), -- Rating (EER requirement)
    comment NVARCHAR(MAX), -- Comment (EER requirement)
    date DATETIME DEFAULT GETDATE(), -- Date (EER requirement)
    -- Additional attributes for web app compatibility
    comments NVARCHAR(MAX),
    is_anonymous BIT DEFAULT 0,
    feedback_date DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Tickets (Updated to match EER requirements)
-- ============================================
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    subject NVARCHAR(200) NOT NULL, -- Subject (EER requirement)
    description NVARCHAR(MAX) NOT NULL, -- Description (EER requirement)
    status NVARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open', 'In Progress', 'Resolved', 'Closed')), -- Status (EER requirement)
    cost DECIMAL(10,2) DEFAULT 0.0, -- Cost (EER requirement)
    -- Additional attributes for web app compatibility
    category NVARCHAR(50) CHECK (category IN ('Booking Issue', 'Payment Issue', 'Vehicle Issue', 'Technical Support', 'General Inquiry', 'Complaint', 'Other')),
    priority NVARCHAR(20) DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')),
    admin_response NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    resolved_at DATETIME
);

-- ============================================
-- INDEXES for Performance
-- ============================================
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_nic ON Users(nic);
CREATE INDEX idx_user_emails_user ON UserEmails(user_id);
CREATE INDEX idx_user_phones_user ON UserPhones(user_id);
CREATE INDEX idx_vehicles_reg_no ON Vehicles(reg_no);
CREATE INDEX idx_vehicles_type ON Vehicles(vehicle_type_id);
CREATE INDEX idx_bookings_user ON Bookings(user_id);
CREATE INDEX idx_bookings_vehicle ON Bookings(vehicle_id);
CREATE INDEX idx_bookings_driver ON Bookings(driver_id);
CREATE INDEX idx_payments_booking ON Payments(booking_id);
CREATE INDEX idx_feedback_vehicle ON Feedback(vehicle_id);
CREATE INDEX idx_tickets_user ON Tickets(user_id);
CREATE INDEX idx_driver_license ON Driver(license_no);

GO
