-- ============================================
-- SQL QUERIES FOR ASSIGNMENT REQUIREMENTS
-- Part D: At least 5 queries covering different types
-- ============================================

USE VehicleRentalDB;
GO

-- ============================================
-- QUERY 1: Simple SELECT
-- Find all available vehicles with their details
-- ============================================
SELECT 
    vehicle_id,
    reg_no,
    make,
    model,
    year,
    daily_rate,
    color,
    status
FROM Vehicles 
WHERE status = 'Available' 
    AND is_active = 1
ORDER BY daily_rate ASC;

-- ============================================
-- QUERY 2: JOIN Query
-- Get booking details with user and vehicle information
-- ============================================
SELECT 
    b.booking_id,
    u.full_name AS customer_name,
    u.email AS customer_email,
    v.make + ' ' + v.model AS vehicle_name,
    v.reg_no,
    d.name AS driver_name,
    b.start_date,
    b.end_date,
    b.pickup_location,
    b.dropoff_location,
    b.total_cost,
    b.status AS booking_status
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
LEFT JOIN Driver d ON b.driver_id = d.driver_id
ORDER BY b.start_date DESC;

-- ============================================
-- QUERY 3: Aggregation Query
-- Calculate total revenue and average booking value
-- ============================================
SELECT 
    COUNT(*) AS total_bookings,
    SUM(total_cost) AS total_revenue,
    AVG(total_cost) AS average_booking_value,
    MIN(total_cost) AS minimum_booking_value,
    MAX(total_cost) AS maximum_booking_value
FROM Bookings 
WHERE status IN ('Completed', 'Approved');

-- ============================================
-- QUERY 4: GROUP BY / HAVING Query
-- Find vehicle types with average rating above 4.0
-- ============================================
SELECT 
    vt.type_name,
    COUNT(f.feedback_id) AS total_feedbacks,
    AVG(CAST(f.rating AS DECIMAL(3,2))) AS average_rating,
    COUNT(DISTINCT f.vehicle_id) AS vehicles_with_feedback
FROM VehicleType vt
INNER JOIN Vehicles v ON vt.type_id = v.vehicle_type_id
INNER JOIN Feedback f ON v.vehicle_id = f.vehicle_id
GROUP BY vt.type_id, vt.type_name
HAVING AVG(CAST(f.rating AS DECIMAL(3,2))) > 4.0
ORDER BY average_rating DESC;

-- ============================================
-- QUERY 5: Subquery Query
-- Find users who have made bookings above the average booking cost
-- ============================================
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    b.booking_id,
    b.total_cost,
    b.start_date,
    b.end_date
FROM Users u
INNER JOIN Bookings b ON u.user_id = b.user_id
WHERE b.total_cost > (
    SELECT AVG(total_cost) 
    FROM Bookings 
    WHERE status IN ('Completed', 'Approved')
)
ORDER BY b.total_cost DESC;

-- ============================================
-- BONUS QUERIES (Additional examples)
-- ============================================

-- BONUS QUERY 1: Complex JOIN with multiple tables
-- Get comprehensive booking report with all related information
SELECT 
    b.booking_id,
    u.full_name AS customer,
    u.nic,
    v.make + ' ' + v.model AS vehicle,
    v.reg_no,
    vt.type_name AS vehicle_type,
    d.name AS driver,
    d.rating AS driver_rating,
    b.start_date,
    b.end_date,
    DATEDIFF(day, b.start_date, b.end_date) + 1 AS rental_days,
    b.total_cost,
    p.method AS payment_method,
    p.status AS payment_status,
    f.rating AS feedback_rating,
    f.comment AS feedback_comment
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
INNER JOIN VehicleType vt ON v.vehicle_type_id = vt.type_id
LEFT JOIN Driver d ON b.driver_id = d.driver_id
LEFT JOIN Payments p ON b.booking_id = p.booking_id
LEFT JOIN Feedback f ON b.booking_id = f.booking_id
ORDER BY b.start_date DESC;

-- BONUS QUERY 2: Window Functions
-- Rank vehicles by their daily rate within each vehicle type
SELECT 
    v.vehicle_id,
    v.reg_no,
    v.make + ' ' + v.model AS vehicle_name,
    vt.type_name,
    v.daily_rate,
    RANK() OVER (PARTITION BY vt.type_name ORDER BY v.daily_rate) AS price_rank_in_category,
    DENSE_RANK() OVER (ORDER BY v.daily_rate) AS overall_price_rank
FROM Vehicles v
INNER JOIN VehicleType vt ON v.vehicle_type_id = vt.type_id
WHERE v.is_active = 1
ORDER BY vt.type_name, v.daily_rate;

-- BONUS QUERY 3: CASE Statement with Aggregation
-- Categorize bookings by cost range and count them
SELECT 
    CASE 
        WHEN total_cost < 100 THEN 'Low Cost (< $100)'
        WHEN total_cost BETWEEN 100 AND 300 THEN 'Medium Cost ($100-$300)'
        WHEN total_cost BETWEEN 300 AND 500 THEN 'High Cost ($300-$500)'
        ELSE 'Premium Cost (> $500)'
    END AS cost_category,
    COUNT(*) AS booking_count,
    AVG(total_cost) AS average_cost,
    SUM(total_cost) AS total_revenue
FROM Bookings
WHERE status IN ('Completed', 'Approved')
GROUP BY 
    CASE 
        WHEN total_cost < 100 THEN 'Low Cost (< $100)'
        WHEN total_cost BETWEEN 100 AND 300 THEN 'Medium Cost ($100-$300)'
        WHEN total_cost BETWEEN 300 AND 500 THEN 'High Cost ($300-$500)'
        ELSE 'Premium Cost (> $500)'
    END
ORDER BY average_cost;

GO
