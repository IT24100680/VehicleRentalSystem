-- ============================================
-- TRIGGERS FOR ASSIGNMENT REQUIREMENTS
-- Part F: Trigger that performs updates, validation, or auditing
-- ============================================

USE VehicleRentalDB;
GO

-- ============================================
-- TRIGGER 1: UpdateVehicleStatusOnBooking
-- This trigger automatically updates vehicle status when booking is approved/completed
-- ============================================
CREATE TRIGGER UpdateVehicleStatusOnBooking
ON Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT operations
    IF EXISTS (SELECT 1 FROM inserted WHERE status = 'Approved')
    BEGIN
        UPDATE v
        SET status = 'Booked',
            updated_at = GETDATE()
        FROM Vehicles v
        INNER JOIN inserted i ON v.vehicle_id = i.vehicle_id
        WHERE i.status = 'Approved';
        
        PRINT 'Vehicle status updated to Booked for approved bookings.';
    END
    
    -- Handle UPDATE operations
    IF EXISTS (SELECT 1 FROM inserted WHERE status = 'Completed')
    BEGIN
        UPDATE v
        SET status = 'Available',
            updated_at = GETDATE()
        FROM Vehicles v
        INNER JOIN inserted i ON v.vehicle_id = i.vehicle_id
        WHERE i.status = 'Completed';
        
        PRINT 'Vehicle status updated to Available for completed bookings.';
    END
    
    -- Handle booking cancellations
    IF EXISTS (SELECT 1 FROM inserted WHERE status = 'Cancelled')
    BEGIN
        UPDATE v
        SET status = 'Available',
            updated_at = GETDATE()
        FROM Vehicles v
        INNER JOIN inserted i ON v.vehicle_id = i.vehicle_id
        WHERE i.status = 'Cancelled';
        
        PRINT 'Vehicle status updated to Available for cancelled bookings.';
    END
END;
GO

-- ============================================
-- TRIGGER 2: ValidateBookingDates
-- This trigger validates booking dates and prevents invalid bookings
-- ============================================
CREATE TRIGGER ValidateBookingDates
ON Bookings
BEFORE INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check for invalid date ranges
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE start_date >= end_date
    )
    BEGIN
        RAISERROR('Start date must be before end date.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check for past start dates (allow same day)
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE start_date < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('Start date cannot be in the past.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check for bookings too far in the future (max 1 year)
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE start_date > DATEADD(year, 1, GETDATE())
    )
    BEGIN
        RAISERROR('Bookings cannot be made more than 1 year in advance.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check for overlapping bookings
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE EXISTS (
            SELECT 1 FROM Bookings b
            WHERE b.vehicle_id = i.vehicle_id
                AND b.status IN ('Approved', 'Pending')
                AND b.booking_id != ISNULL(i.booking_id, 0)
                AND (
                    (i.start_date BETWEEN b.start_date AND b.end_date) OR
                    (i.end_date BETWEEN b.start_date AND b.end_date) OR
                    (i.start_date <= b.start_date AND i.end_date >= b.end_date)
                )
        )
    )
    BEGIN
        RAISERROR('Vehicle is already booked for the selected date range.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    PRINT 'Booking date validation passed successfully.';
END;
GO

-- ============================================
-- TRIGGER 3: AuditBookingChanges
-- This trigger creates an audit trail for booking changes
-- ============================================
CREATE TABLE BookingAudit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT,
    user_id INT,
    vehicle_id INT,
    old_status NVARCHAR(20),
    new_status NVARCHAR(20),
    old_total_cost DECIMAL(10,2),
    new_total_cost DECIMAL(10,2),
    change_type NVARCHAR(10), -- INSERT, UPDATE, DELETE
    changed_by NVARCHAR(100),
    change_date DATETIME DEFAULT GETDATE(),
    old_values NVARCHAR(MAX),
    new_values NVARCHAR(MAX)
);

CREATE TRIGGER AuditBookingChanges
ON Bookings
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT operations
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO BookingAudit (
            booking_id, user_id, vehicle_id, new_status, new_total_cost,
            change_type, changed_by, new_values
        )
        SELECT 
            booking_id, user_id, vehicle_id, status, total_cost,
            'INSERT', SYSTEM_USER,
            'Booking created: ' + CAST(booking_id AS NVARCHAR(10))
        FROM inserted;
    END
    
    -- Handle UPDATE operations
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO BookingAudit (
            booking_id, user_id, vehicle_id, old_status, new_status,
            old_total_cost, new_total_cost, change_type, changed_by,
            old_values, new_values
        )
        SELECT 
            i.booking_id, i.user_id, i.vehicle_id, 
            d.status, i.status, d.total_cost, i.total_cost,
            'UPDATE', SYSTEM_USER,
            'Status: ' + ISNULL(d.status, 'NULL') + ', Cost: ' + ISNULL(CAST(d.total_cost AS NVARCHAR(20)), 'NULL'),
            'Status: ' + ISNULL(i.status, 'NULL') + ', Cost: ' + ISNULL(CAST(i.total_cost AS NVARCHAR(20)), 'NULL')
        FROM inserted i
        INNER JOIN deleted d ON i.booking_id = d.booking_id
        WHERE i.status != d.status OR i.total_cost != d.total_cost;
    END
    
    -- Handle DELETE operations
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO BookingAudit (
            booking_id, user_id, vehicle_id, old_status, old_total_cost,
            change_type, changed_by, old_values
        )
        SELECT 
            booking_id, user_id, vehicle_id, status, total_cost,
            'DELETE', SYSTEM_USER,
            'Booking deleted: ' + CAST(booking_id AS NVARCHAR(10))
        FROM deleted;
    END
END;
GO

-- ============================================
-- TRIGGER 4: UpdateDriverRating
-- This trigger automatically updates driver rating based on feedback
-- ============================================
CREATE TRIGGER UpdateDriverRating
ON Feedback
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Calculate new average rating for drivers
    UPDATE d
    SET rating = (
        SELECT AVG(CAST(f.rating AS DECIMAL(3,2)))
        FROM Feedback f
        INNER JOIN Bookings b ON f.booking_id = b.booking_id
        WHERE b.driver_id = d.driver_id
            AND f.rating IS NOT NULL
    ),
    updated_at = GETDATE()
    FROM Driver d
    WHERE d.driver_id IN (
        SELECT DISTINCT b.driver_id
        FROM Bookings b
        WHERE b.booking_id IN (
            SELECT booking_id FROM inserted
            UNION
            SELECT booking_id FROM deleted
        )
    );
    
    PRINT 'Driver ratings updated based on feedback changes.';
END;
GO

-- ============================================
-- TRIGGER 5: ValidatePaymentAmount
-- This trigger validates payment amounts against booking costs
-- ============================================
CREATE TRIGGER ValidatePaymentAmount
ON Payments
BEFORE INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if payment amount matches booking cost
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN Bookings b ON i.booking_id = b.booking_id
        WHERE ABS(i.amount - b.total_cost) > 0.01 -- Allow small rounding differences
    )
    BEGIN
        DECLARE @BookingCost DECIMAL(10,2);
        DECLARE @PaymentAmount DECIMAL(10,2);
        DECLARE @BookingID INT;
        
        SELECT TOP 1 
            @BookingCost = b.total_cost,
            @PaymentAmount = i.amount,
            @BookingID = i.booking_id
        FROM inserted i
        INNER JOIN Bookings b ON i.booking_id = b.booking_id
        WHERE ABS(i.amount - b.total_cost) > 0.01;
        
        RAISERROR('Payment amount $%.2f does not match booking cost $%.2f for booking %d.', 
                  16, 1, @PaymentAmount, @BookingCost, @BookingID);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check for negative payment amounts
    IF EXISTS (SELECT 1 FROM inserted WHERE amount < 0)
    BEGIN
        RAISERROR('Payment amount cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    PRINT 'Payment amount validation passed successfully.';
END;
GO

-- ============================================
-- EXAMPLE USAGE AND TESTING OF TRIGGERS
-- ============================================

-- Test 1: Insert a new booking (should trigger vehicle status update)
INSERT INTO Bookings (user_id, vehicle_id, driver_id, start_date, end_date, pickup_location, dropoff_location, total_cost, status)
VALUES (2, 1, 1, '2024-04-01', '2024-04-03', 'Test Location', 'Test Location', 150.00, 'Approved');

-- Test 2: Update booking status to completed (should trigger vehicle status update)
UPDATE Bookings 
SET status = 'Completed' 
WHERE booking_id = (SELECT MAX(booking_id) FROM Bookings WHERE user_id = 2);

-- Test 3: Try to insert invalid booking (should fail validation)
-- This will fail due to start_date >= end_date
/*
INSERT INTO Bookings (user_id, vehicle_id, driver_id, start_date, end_date, pickup_location, dropoff_location, total_cost, status)
VALUES (2, 1, 1, '2024-04-05', '2024-04-03', 'Test Location', 'Test Location', 150.00, 'Approved');
*/

-- Test 4: Insert feedback (should trigger driver rating update)
INSERT INTO Feedback (booking_id, user_id, vehicle_id, rating, comment)
VALUES ((SELECT MAX(booking_id) FROM Bookings WHERE user_id = 2), 2, 1, 5, 'Excellent service!');

-- Test 5: Insert payment with wrong amount (should fail validation)
-- This will fail due to amount mismatch
/*
INSERT INTO Payments (booking_id, user_id, amount, method, status, transaction_ref)
VALUES ((SELECT MAX(booking_id) FROM Bookings WHERE user_id = 2), 2, 200.00, 'Credit Card', 'Approved', 'TXN_TEST');
*/

-- View audit trail
SELECT * FROM BookingAudit ORDER BY change_date DESC;

GO

