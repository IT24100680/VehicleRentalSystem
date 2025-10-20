-- FILE: src/main/resources/sql/sample_data.sql

USE VehicleRentalDB;
GO

-- Insert Default Admin User (Password: admin123)
INSERT INTO Users (full_name, email, phone, password_hash, role, address, city, state, zip_code, is_active)
VALUES
('Admin User', 'admin@vehiclerental.com', '1234567890',
 '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- SHA-256 of 'admin123'
 'ADMIN', '123 Admin Street', 'New York', 'NY', '10001', 1);

-- Insert Sample Customer (Password: customer123)
INSERT INTO Users (full_name, email, phone, password_hash, role, address, city, state, zip_code, license_number, date_of_birth, is_active)
VALUES
    ('John Doe', 'john.doe@email.com', '9876543210',
     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', -- SHA-256 of 'customer123'
     'CUSTOMER', '456 Customer Ave', 'Los Angeles', 'CA', '90001', 'DL123456789', '1990-05-15', 1);

-- Insert Sample Vehicles
INSERT INTO Vehicles (vehicle_name, brand, model, year, category, fuel_type, transmission, seating_capacity, price_per_day, vehicle_number, color, image_url, features, availability_status)
VALUES
    ('Toyota Camry 2023', 'Toyota', 'Camry', 2023, 'Sedan', 'Hybrid', 'Automatic', 5, 75.00, 'CAM2023-001', 'Silver', 'assets/images/vehicles/camry.jpg', 'GPS, Bluetooth, Backup Camera, Cruise Control', 'Available'),
    ('Honda CR-V', 'Honda', 'CR-V', 2023, 'SUV', 'Petrol', 'Automatic', 7, 95.00, 'CRV2023-002', 'Black', 'assets/images/vehicles/crv.jpg', 'All-Wheel Drive, Sunroof, Leather Seats', 'Available'),
    ('Tesla Model 3', 'Tesla', 'Model 3', 2024, 'Luxury', 'Electric', 'Automatic', 5, 150.00, 'TES2024-003', 'White', 'assets/images/vehicles/tesla.jpg', 'Autopilot, Premium Audio, Glass Roof', 'Available'),
    ('Ford Transit', 'Ford', 'Transit', 2022, 'Van', 'Diesel', 'Manual', 12, 120.00, 'FOR2022-004', 'Blue', 'assets/images/vehicles/transit.jpg', 'Large Cargo Space, Rear Camera', 'Available'),
    ('BMW X5', 'BMW', 'X5', 2023, 'Luxury', 'Petrol', 'Automatic', 5, 180.00, 'BMW2023-005', 'Gray', 'assets/images/vehicles/bmwx5.jpg', 'Premium Package, Adaptive Cruise, Heated Seats', 'Available');

GO