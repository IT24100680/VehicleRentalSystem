-- ============================================
-- STORED PROCEDURE FOR ASSIGNMENT REQUIREMENTS
-- Part E: One stored function/procedure relevant to the system
-- ============================================

USE VehicleRentalDB;
GO

-- ============================================
-- STORED PROCEDURE: CalculateBookingCost
-- This procedure calculates the total cost for a booking
-- considering vehicle daily rate, duration, and any discounts
-- ============================================
CREATE PROCEDURE CalculateBookingCost
    @VehicleID INT,
    @StartDate DATE,
    @EndDate DATE,
    @DiscountPercent DECIMAL(5,2) = 0.0,
    @TotalCost DECIMAL(10,2) OUTPUT,
    @RentalDays INT OUTPUT,
    @DailyRate DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(255);
    
    -- Validate input parameters
    IF @VehicleID IS NULL OR @StartDate IS NULL OR @EndDate IS NULL
    BEGIN
        SET @ErrorMessage = 'VehicleID, StartDate, and EndDate are required parameters.';
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END
    
    IF @StartDate >= @EndDate
    BEGIN
        SET @ErrorMessage = 'StartDate must be before EndDate.';
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END
    
    -- Check if vehicle exists and is available
    IF NOT EXISTS (SELECT 1 FROM Vehicles WHERE vehicle_id = @VehicleID AND is_active = 1)
    BEGIN
        SET @ErrorMessage = 'Vehicle not found or not active.';
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END
    
    -- Get vehicle daily rate
    SELECT @DailyRate = daily_rate
    FROM Vehicles
    WHERE vehicle_id = @VehicleID;
    
    -- Calculate rental days
    SET @RentalDays = DATEDIFF(day, @StartDate, @EndDate) + 1;
    
    -- Calculate base cost
    SET @TotalCost = @DailyRate * @RentalDays;
    
    -- Apply discount if provided
    IF @DiscountPercent > 0
    BEGIN
        SET @TotalCost = @TotalCost * (1 - @DiscountPercent / 100);
    END
    
    -- Round to 2 decimal places
    SET @TotalCost = ROUND(@TotalCost, 2);
    
    -- Log the calculation (optional)
    PRINT 'Booking cost calculated successfully:';
    PRINT 'Vehicle ID: ' + CAST(@VehicleID AS NVARCHAR(10));
    PRINT 'Daily Rate: $' + CAST(@DailyRate AS NVARCHAR(10));
    PRINT 'Rental Days: ' + CAST(@RentalDays AS NVARCHAR(10));
    PRINT 'Discount: ' + CAST(@DiscountPercent AS NVARCHAR(10)) + '%';
    PRINT 'Total Cost: $' + CAST(@TotalCost AS NVARCHAR(10));
END;
GO

-- ============================================
-- STORED FUNCTION: GetVehicleAvailability
-- This function checks if a vehicle is available for a given date range
-- ============================================
CREATE FUNCTION GetVehicleAvailability(
    @VehicleID INT,
    @StartDate DATE,
    @EndDate DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT = 1;
    
    -- Check if vehicle exists and is active
    IF NOT EXISTS (SELECT 1 FROM Vehicles WHERE vehicle_id = @VehicleID AND is_active = 1)
    BEGIN
        RETURN 0;
    END
    
    -- Check if vehicle is available (not in maintenance or unavailable)
    IF EXISTS (SELECT 1 FROM Vehicles WHERE vehicle_id = @VehicleID AND status IN ('Maintenance', 'Unavailable'))
    BEGIN
        RETURN 0;
    END
    
    -- Check for conflicting bookings
    IF EXISTS (
        SELECT 1 
        FROM Bookings 
        WHERE vehicle_id = @VehicleID 
            AND status IN ('Approved', 'Pending')
            AND (
                (@StartDate BETWEEN start_date AND end_date) OR
                (@EndDate BETWEEN start_date AND end_date) OR
                (@StartDate <= start_date AND @EndDate >= end_date)
            )
    )
    BEGIN
        SET @IsAvailable = 0;
    END
    
    RETURN @IsAvailable;
END;
GO

-- ============================================
-- STORED PROCEDURE: GetCustomerBookingHistory
-- This procedure retrieves comprehensive booking history for a customer
-- ============================================
CREATE PROCEDURE GetCustomerBookingHistory
    @UserID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range if not provided (last 6 months)
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(month, -6, GETDATE());
    IF @EndDate IS NULL
        SET @EndDate = GETDATE();
    
    SELECT 
        b.booking_id,
        b.start_date,
        b.end_date,
        DATEDIFF(day, b.start_date, b.end_date) + 1 AS rental_days,
        v.make + ' ' + v.model AS vehicle_name,
        v.reg_no,
        vt.type_name AS vehicle_type,
        b.total_cost,
        b.status AS booking_status,
        p.method AS payment_method,
        p.status AS payment_status,
        f.rating AS feedback_rating,
        f.comment AS feedback_comment,
        CASE 
            WHEN b.status = 'Completed' THEN 'Completed'
            WHEN b.status = 'Approved' AND b.end_date >= GETDATE() THEN 'Active'
            WHEN b.status = 'Approved' AND b.end_date < GETDATE() THEN 'Overdue'
            ELSE b.status
        END AS booking_status_description
    FROM Bookings b
    INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
    INNER JOIN VehicleType vt ON v.vehicle_type_id = vt.type_id
    LEFT JOIN Payments p ON b.booking_id = p.booking_id
    LEFT JOIN Feedback f ON b.booking_id = f.booking_id
    WHERE b.user_id = @UserID
        AND b.start_date BETWEEN @StartDate AND @EndDate
    ORDER BY b.start_date DESC;
    
    -- Return summary statistics
    SELECT 
        COUNT(*) AS total_bookings,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_bookings,
        SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_bookings,
        SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
        SUM(CASE WHEN status IN ('Completed', 'Approved') THEN total_cost ELSE 0 END) AS total_spent,
        AVG(CASE WHEN status IN ('Completed', 'Approved') THEN total_cost ELSE NULL END) AS average_booking_value
    FROM Bookings
    WHERE user_id = @UserID
        AND start_date BETWEEN @StartDate AND @EndDate;
END;
GO

-- ============================================
-- EXAMPLE USAGE OF STORED PROCEDURES
-- ============================================

-- Example 1: Calculate booking cost
DECLARE @Cost DECIMAL(10,2), @Days INT, @Rate DECIMAL(10,2);
EXEC CalculateBookingCost 
    @VehicleID = 1,
    @StartDate = '2024-03-15',
    @EndDate = '2024-03-18',
    @DiscountPercent = 10.0,
    @TotalCost = @Cost OUTPUT,
    @RentalDays = @Days OUTPUT,
    @DailyRate = @Rate OUTPUT;

SELECT @Cost AS TotalCost, @Days AS RentalDays, @Rate AS DailyRate;

-- Example 2: Check vehicle availability
SELECT dbo.GetVehicleAvailability(1, '2024-03-15', '2024-03-18') AS IsAvailable;

-- Example 3: Get customer booking history
EXEC GetCustomerBookingHistory @UserID = 2;

GO

