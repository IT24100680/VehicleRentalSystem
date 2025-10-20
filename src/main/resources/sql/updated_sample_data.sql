-- ============================================
-- SAMPLE DATA FOR ASSIGNMENT REQUIREMENTS
-- At least 5 records per table
-- ============================================

USE VehicleRentalDB;
GO

-- ============================================
-- Insert VehicleType data (5+ records)
-- ============================================
INSERT INTO VehicleType (type_name, base_rate, description)
VALUES
    ('Economy Car', 50.00, 'Basic transportation with good fuel efficiency'),
    ('Luxury Car', 150.00, 'Premium vehicles with advanced features'),
    ('SUV', 100.00, 'Sport Utility Vehicles for family trips'),
    ('Van', 80.00, 'Large capacity vehicles for groups'),
    ('Motorcycle', 40.00, 'Two-wheeled vehicles for city commuting'),
    ('Truck', 120.00, 'Heavy-duty vehicles for cargo transport');

-- ============================================
-- Insert Users data (5+ records)
-- ============================================
INSERT INTO Users (full_name, email, phone, password_hash, role, street, city, postal_code, date_of_birth, nic, license_number, is_active)
VALUES
    ('Admin User', 'admin@vehiclerental.com', '1234567890', 
     '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- SHA-256 of 'admin123'
     'ADMIN', '123 Admin Street', 'New York', '10001', '1985-01-15', 'NIC123456789', 'DL123456789', 1),
    
    ('John Doe', 'john.doe@email.com', '9876543210',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', -- SHA-256 of 'customer123'
     'CUSTOMER', '456 Customer Ave', 'Los Angeles', '90001', '1990-05-15', 'NIC987654321', 'DL987654321', 1),
    
    ('Jane Smith', 'jane.smith@email.com', '5551234567',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
     'CUSTOMER', '789 Oak Street', 'Chicago', '60601', '1988-12-03', 'NIC555123456', 'DL555123456', 1),
    
    ('Mike Johnson', 'mike.johnson@email.com', '4449876543',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
     'CUSTOMER', '321 Pine Road', 'Houston', '77001', '1992-08-22', 'NIC444987654', 'DL444987654', 1),
    
    ('Sarah Wilson', 'sarah.wilson@email.com', '3334567890',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
     'CUSTOMER', '654 Elm Avenue', 'Phoenix', '85001', '1987-03-10', 'NIC333456789', 'DL333456789', 1),
    
    ('David Brown', 'david.brown@email.com', '2227890123',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
     'CUSTOMER', '987 Maple Drive', 'Philadelphia', '19101', '1991-11-18', 'NIC222789012', 'DL222789012', 1);

-- ============================================
-- Insert UserEmails data (Multivalued attribute)
-- ============================================
INSERT INTO UserEmails (user_id, email, is_primary)
VALUES
    (2, 'john.doe@email.com', 1),
    (2, 'john.personal@gmail.com', 0),
    (3, 'jane.smith@email.com', 1),
    (3, 'jane.work@company.com', 0),
    (4, 'mike.johnson@email.com', 1),
    (5, 'sarah.wilson@email.com', 1),
    (5, 'sarah.family@yahoo.com', 0),
    (6, 'david.brown@email.com', 1);

-- ============================================
-- Insert UserPhones data (Multivalued attribute)
-- ============================================
INSERT INTO UserPhones (user_id, phone, phone_type, is_primary)
VALUES
    (2, '9876543210', 'Mobile', 1),
    (2, '555-1234', 'Home', 0),
    (3, '5551234567', 'Mobile', 1),
    (3, '555-5678', 'Work', 0),
    (4, '4449876543', 'Mobile', 1),
    (5, '3334567890', 'Mobile', 1),
    (6, '2227890123', 'Mobile', 1);

-- ============================================
-- Insert Vehicles data (5+ records)
-- ============================================
INSERT INTO Vehicles (reg_no, make, model, year, daily_rate, vehicle_type_id, status, vehicle_name, fuel_type, transmission, seating_capacity, color, image_url, features, is_active)
VALUES
    ('ABC-1234', 'Toyota', 'Camry', 2023, 75.00, 1, 'Available', 'Toyota Camry 2023', 'Hybrid', 'Automatic', 5, 'Silver', 'assets/images/vehicles/camry.jpg', 'GPS, Bluetooth, Backup Camera', 1),
    ('XYZ-5678', 'Honda', 'CR-V', 2023, 95.00, 3, 'Available', 'Honda CR-V', 'Petrol', 'Automatic', 7, 'Black', 'assets/images/vehicles/crv.jpg', 'All-Wheel Drive, Sunroof', 1),
    ('TES-2024', 'Tesla', 'Model 3', 2024, 150.00, 2, 'Available', 'Tesla Model 3', 'Electric', 'Automatic', 5, 'White', 'assets/images/vehicles/tesla.jpg', 'Autopilot, Premium Audio', 1),
    ('FOR-9876', 'Ford', 'Transit', 2022, 80.00, 4, 'Available', 'Ford Transit', 'Diesel', 'Manual', 12, 'Blue', 'assets/images/vehicles/transit.jpg', 'Large Cargo Space', 1),
    ('BMW-5432', 'BMW', 'X5', 2023, 180.00, 2, 'Available', 'BMW X5', 'Petrol', 'Automatic', 5, 'Gray', 'assets/images/vehicles/bmwx5.jpg', 'Premium Package, Adaptive Cruise', 1),
    ('KAW-1111', 'Kawasaki', 'Ninja', 2023, 40.00, 5, 'Available', 'Kawasaki Ninja', 'Petrol', 'Manual', 2, 'Green', 'assets/images/vehicles/ninja.jpg', 'Sport Mode, LED Lights', 1),
    ('CHE-2222', 'Chevrolet', 'Silverado', 2022, 120.00, 6, 'Available', 'Chevrolet Silverado', 'Petrol', 'Automatic', 3, 'Red', 'assets/images/vehicles/silverado.jpg', 'Towing Package, 4WD', 1);

-- ============================================
-- Insert Vehicle Specialization data
-- ============================================
-- Car specialization
INSERT INTO Car (vehicle_id, trunk_size, car_type)
VALUES
    (1, 15.1, 'Sedan'),
    (3, 12.0, 'Sedan'),
    (5, 18.0, 'Sedan');

-- Van specialization
INSERT INTO Van (vehicle_id, capacity, cargo_space, van_type)
VALUES
    (2, 7, 75.5, 'Passenger'),
    (4, 12, 200.0, 'Mixed');

-- Bike specialization
INSERT INTO Bike (vehicle_id, engine_cc, bike_type)
VALUES
    (6, 636, 'Sport');

-- ============================================
-- Insert Driver data (5+ records)
-- ============================================
INSERT INTO Driver (name, license_no, rating, availability, phone, email, address, hire_date, is_active)
VALUES
    ('Robert Davis', 'DRV001234567', 4.8, 1, '111-222-3333', 'robert.davis@vehiclerental.com', '100 Driver Lane, New York', '2022-01-15', 1),
    ('Lisa Anderson', 'DRV002345678', 4.6, 1, '222-333-4444', 'lisa.anderson@vehiclerental.com', '200 Driver Street, Los Angeles', '2022-03-20', 1),
    ('James Wilson', 'DRV003456789', 4.9, 1, '333-444-5555', 'james.wilson@vehiclerental.com', '300 Driver Avenue, Chicago', '2021-11-10', 1),
    ('Maria Garcia', 'DRV004567890', 4.7, 0, '444-555-6666', 'maria.garcia@vehiclerental.com', '400 Driver Road, Houston', '2022-06-05', 1),
    ('Kevin Lee', 'DRV005678901', 4.5, 1, '555-666-7777', 'kevin.lee@vehiclerental.com', '500 Driver Boulevard, Phoenix', '2022-08-12', 1),
    ('Amanda Taylor', 'DRV006789012', 4.8, 1, '666-777-8888', 'amanda.taylor@vehiclerental.com', '600 Driver Court, Philadelphia', '2021-12-01', 1);

-- ============================================
-- Insert Bookings data (5+ records)
-- ============================================
INSERT INTO Bookings (user_id, vehicle_id, driver_id, start_date, end_date, pickup_location, dropoff_location, total_cost, status, total_days, special_requests, created_at)
VALUES
    (2, 1, 1, '2024-01-15', '2024-01-17', 'Los Angeles Airport', 'Los Angeles Airport', 150.00, 'Completed', 2, 'Need GPS navigation', '2024-01-10'),
    (3, 2, 2, '2024-01-20', '2024-01-25', 'Chicago Downtown', 'Chicago Downtown', 475.00, 'Approved', 5, 'Child seat required', '2024-01-15'),
    (4, 3, 3, '2024-02-01', '2024-02-03', 'Houston Convention Center', 'Houston Convention Center', 300.00, 'Pending', 2, 'Premium service requested', '2024-01-25'),
    (5, 4, 4, '2024-02-10', '2024-02-15', 'Phoenix Mall', 'Phoenix Mall', 400.00, 'Approved', 5, 'Group booking for 8 people', '2024-02-01'),
    (6, 5, 5, '2024-02-20', '2024-02-22', 'Philadelphia Airport', 'Philadelphia Airport', 360.00, 'Completed', 2, 'Luxury service', '2024-02-10'),
    (2, 6, 6, '2024-03-01', '2024-03-05', 'Los Angeles Beach', 'Los Angeles Beach', 160.00, 'Approved', 4, 'Weekend trip', '2024-02-20');

-- ============================================
-- Insert Payments data (5+ records)
-- ============================================
INSERT INTO Payments (booking_id, user_id, amount, method, status, transaction_ref, payment_date, transaction_id, card_holder_name)
VALUES
    (1, 2, 150.00, 'Credit Card', 'Approved', 'TXN001234567890', '2024-01-10', 'TXN001234567890', 'John Doe'),
    (2, 3, 475.00, 'Debit Card', 'Approved', 'TXN002345678901', '2024-01-15', 'TXN002345678901', 'Jane Smith'),
    (3, 4, 300.00, 'PayPal', 'Pending', 'TXN003456789012', '2024-01-25', 'TXN003456789012', 'Mike Johnson'),
    (4, 5, 400.00, 'Bank Transfer', 'Approved', 'TXN004567890123', '2024-02-01', 'TXN004567890123', 'Sarah Wilson'),
    (5, 6, 360.00, 'Credit Card', 'Approved', 'TXN005678901234', '2024-02-10', 'TXN005678901234', 'David Brown'),
    (6, 2, 160.00, 'Debit Card', 'Approved', 'TXN006789012345', '2024-02-20', 'TXN006789012345', 'John Doe');

-- ============================================
-- Insert Feedback data (5+ records)
-- ============================================
INSERT INTO Feedback (booking_id, user_id, vehicle_id, rating, comment, date, comments, is_anonymous, feedback_date)
VALUES
    (1, 2, 1, 5, 'Excellent service and clean vehicle', '2024-01-18', 'Excellent service and clean vehicle', 0, '2024-01-18'),
    (2, 3, 2, 4, 'Good vehicle, driver was professional', '2024-01-26', 'Good vehicle, driver was professional', 0, '2024-01-26'),
    (3, 4, 3, 5, 'Amazing Tesla experience!', '2024-02-04', 'Amazing Tesla experience!', 0, '2024-02-04'),
    (4, 5, 4, 4, 'Perfect for our group trip', '2024-02-16', 'Perfect for our group trip', 0, '2024-02-16'),
    (5, 6, 5, 5, 'Luxury service exceeded expectations', '2024-02-23', 'Luxury service exceeded expectations', 0, '2024-02-23'),
    (6, 2, 6, 4, 'Fun motorcycle ride, great for city trips', '2024-03-06', 'Fun motorcycle ride, great for city trips', 0, '2024-03-06');

-- ============================================
-- Insert Tickets data (5+ records)
-- ============================================
INSERT INTO Tickets (user_id, subject, description, status, cost, category, priority, admin_response, created_at)
VALUES
    (2, 'Booking Modification Request', 'Need to change pickup location for booking #1', 'Resolved', 0.0, 'Booking Issue', 'Medium', 'Location changed successfully', '2024-01-12'),
    (3, 'Payment Refund Request', 'Requesting refund for cancelled booking', 'Open', 0.0, 'Payment Issue', 'High', NULL, '2024-01-20'),
    (4, 'Vehicle Maintenance Issue', 'Air conditioning not working properly', 'In Progress', 0.0, 'Vehicle Issue', 'High', 'Technician assigned, repair in progress', '2024-02-05'),
    (5, 'Driver Rating Inquiry', 'How to rate driver after trip completion?', 'Resolved', 0.0, 'General Inquiry', 'Low', 'Rating system explained via email', '2024-02-12'),
    (6, 'Account Password Reset', 'Cannot access account, need password reset', 'Resolved', 0.0, 'Technical Support', 'Medium', 'Password reset link sent to email', '2024-02-25'),
    (2, 'Late Return Fee Dispute', 'Disputing late return fee for booking', 'Open', 25.0, 'Complaint', 'High', NULL, '2024-03-08');

GO
