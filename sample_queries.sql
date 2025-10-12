-- =====================================================
-- Hotel Management Database System
-- Sample Queries and Business Reports
-- Author: Qinyi Qiu
-- Date: October 2023 (updated 2025 revision)
-- =====================================================

USE hotel_management_database;
GO

PRINT '=== HOTEL MANAGEMENT SAMPLE QUERIES ===';
PRINT '';

-- =====================================================
-- 1. KEY BUSINESS STATISTICS DASHBOARD
-- =====================================================

PRINT '1. KEY BUSINESS STATISTICS DASHBOARD';
PRINT '-----------------------------------';
GO

-- Query 1.1: Complete Business Statistics Summary
PRINT '1.1 Complete Business Statistics Summary';
SELECT 
    -- Occupancy Rate
    CAST((
        SELECT COUNT(*) 
        FROM room r 
        INNER JOIN room_status rs ON r.room_status_id = rs.room_status_id 
        WHERE rs.room_status_name = 'Booked'
    ) * 100.0 / (SELECT COUNT(*) FROM room) AS DECIMAL(5,2)) AS 'Occupancy_Rate_%',
    
    -- Top Payment Method and Percentage
    (SELECT TOP 1 pm.payment_method_name 
     FROM [transaction] t 
     INNER JOIN payment_method pm ON t.payment_method_id = pm.payment_method_id 
     GROUP BY pm.payment_method_name 
     ORDER BY COUNT(*) DESC
    ) AS 'Top_Payment_Method',
    
    CAST((
        SELECT COUNT(*) 
        FROM [transaction] t 
        INNER JOIN payment_method pm ON t.payment_method_id = pm.payment_method_id 
        WHERE pm.payment_method_name = 'Credit Card'
    ) * 100.0 / (SELECT COUNT(*) FROM [transaction]) AS DECIMAL(5,2)) AS 'Credit_Card_%',
    
    -- Membership Distribution
    CAST((SELECT COUNT(*) FROM membership WHERE membership_code = 'SE') * 100.0 / 
         (SELECT COUNT(*) FROM membership) AS DECIMAL(5,2)) AS 'Silver_Members_%',
    CAST((SELECT COUNT(*) FROM membership WHERE membership_code = 'GE') * 100.0 / 
         (SELECT COUNT(*) FROM membership) AS DECIMAL(5,2)) AS 'Gold_Members_%',
    CAST((SELECT COUNT(*) FROM membership WHERE membership_code = 'PE') * 100.0 / 
         (SELECT COUNT(*) FROM membership) AS DECIMAL(5,2)) AS 'Platinum_Members_%',
    
    -- International Guests
    (SELECT COUNT(DISTINCT nationality) FROM customer) AS 'Nationality_Count';
GO

-- =====================================================
-- 2. ROOM MANAGEMENT & AVAILABILITY QUERIES
-- =====================================================

PRINT '';
PRINT '2. ROOM MANAGEMENT & AVAILABILITY';
PRINT '----------------------------------';
GO

-- Query 2.1: Find available rooms for specific criteria
PRINT '2.1 Available rooms for 3+ guests, under $300, pet-friendly';
SELECT 
    r.room_number AS 'Room Number',
    rt.room_type_name AS 'Room Type',
    rt.max_capacity AS 'Max Capacity',
    rt.price_usd AS 'Price (USD)',
    rs.room_status_name AS 'Status'
FROM room r
INNER JOIN room_type rt ON r.room_type_id = rt.room_type_id
INNER JOIN room_status rs ON r.room_status_id = rs.room_status_id
WHERE rt.max_capacity >= 3
    AND rt.price_usd < 300
    AND r.is_pet_friendly = 1
    AND rs.room_status_name = 'Vacant';
GO

-- Query 2.2: Rooms needing cleaning
PRINT '2.2 Rooms currently being cleaned';
SELECT 
    r.room_number AS 'Room Number',
    rt.room_type_name AS 'Room Type'
FROM room r
INNER JOIN room_type rt ON r.room_type_id = rt.room_type_id
INNER JOIN room_status rs ON r.room_status_id = rs.room_status_id
WHERE rs.room_status_name = 'Being cleaned';
GO

-- =====================================================
-- 3. CUSTOMER & BOOKING QUERIES
-- =====================================================

PRINT '';
PRINT '3. CUSTOMER & BOOKING MANAGEMENT';
PRINT '--------------------------------';
GO

-- Query 3.1: Current guests with contact information
PRINT '3.1 Current hotel guests';
SELECT 
    rb.room_number AS 'Room',
    c.first_name + ' ' + c.last_name AS 'Guest Name',
    cc.phone_number AS 'Phone',
    rb.number_of_guests AS 'Guests',
    rb.from_date AS 'Check-In',
    rb.to_date AS 'Check-Out'
FROM room_booked rb
INNER JOIN customer c ON rb.customer_id = c.customer_id
INNER JOIN customer_contact cc ON c.customer_id = cc.customer_id
WHERE GETDATE() BETWEEN rb.from_date AND rb.to_date
ORDER BY rb.room_number;
GO

-- Query 3.2: Customers celebrating birthdays during their stay
PRINT '3.2 Guests celebrating birthdays during stay';
SELECT 
    c.first_name + ' ' + c.last_name AS 'Guest Name',
    c.birth_date AS 'Birthday',
    rb.room_number AS 'Room',
    rb.from_date AS 'Check-In',
    rb.to_date AS 'Check-Out'
FROM customer c
INNER JOIN room_booked rb ON c.customer_id = rb.customer_id
WHERE MONTH(c.birth_date) = MONTH(rb.from_date)
    OR MONTH(c.birth_date) = MONTH(rb.to_date)
    OR MONTH(c.birth_date) = MONTH(GETDATE());
GO

-- =====================================================
-- 4. MEMBERSHIP & LOYALTY QUERIES
-- =====================================================

PRINT '';
PRINT '4. MEMBERSHIP & LOYALTY PROGRAM';
PRINT '------------------------------';
GO

-- Query 4.1: First members to join each tier
PRINT '4.1 First Silver Elite members';
SELECT TOP 3 
    c.first_name + ' ' + c.last_name AS 'Member Name',
    m.from_date AS 'Join Date'
FROM membership m
INNER JOIN customer c ON m.customer_id = c.customer_id
INNER JOIN membership_info mi ON m.membership_code = mi.membership_code
WHERE mi.membership_name = 'Silver Elite'
ORDER BY m.from_date ASC;
GO

-- Query 4.2: Members with expiring memberships (next 30 days)
PRINT '4.2 Memberships expiring soon';
SELECT 
    c.first_name + ' ' + c.last_name AS 'Member Name',
    mi.membership_name AS 'Membership Tier',
    m.to_date AS 'Expiry Date'
FROM membership m
INNER JOIN customer c ON m.customer_id = c.customer_id
INNER JOIN membership_info mi ON m.membership_code = mi.membership_code
WHERE m.to_date BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())
ORDER BY m.to_date;
GO

-- =====================================================
-- 5. EMPLOYEE & STAFF MANAGEMENT QUERIES
-- =====================================================

PRINT '';
PRINT '5. EMPLOYEE & STAFF MANAGEMENT';
PRINT '-----------------------------';
GO

-- Query 5.1: Young employees (under 25)
PRINT '5.1 Employees under 25 years old';
SELECT 
    employee_id AS 'Employee ID',
    first_name + ' ' + last_name AS 'Name',
    DATEDIFF(YEAR, birth_date, GETDATE()) AS 'Age',
    department_id AS 'Dept ID'
FROM employee
WHERE DATEDIFF(YEAR, birth_date, GETDATE()) < 25
ORDER BY Age;
GO

-- Query 5.2: Department gender and salary statistics
PRINT '5.2 Departmental gender and salary overview';
SELECT 
    d.department_name AS 'Department',
    COUNT(*) AS 'Total Employees',
    SUM(CASE WHEN e.gender = 'M' THEN 1 ELSE 0 END) AS 'Male',
    SUM(CASE WHEN e.gender = 'F' THEN 1 ELSE 0 END) AS 'Female',
    AVG(e.hourly_salary_usd) AS 'Avg Hourly Salary'
FROM employee e
INNER JOIN department d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY COUNT(*) DESC;
GO

-- Query 5.3: Find employee's manager
PRINT '5.3 Find Evan Harris's manager';
SELECT 
    e.employee_id AS 'Employee ID',
    e.first_name + ' ' + e.last_name AS 'Employee Name',
    d.department_name AS 'Department',
    m.employee_id AS 'Manager ID', 
    m.first_name + ' ' + m.last_name AS 'Manager Name',
    ec.phone_number AS 'Manager Phone'
FROM employee e
INNER JOIN department d ON e.department_id = d.department_id
INNER JOIN employee m ON d.manager_id = m.employee_id
INNER JOIN employee_contact ec ON m.employee_id = ec.employee_id
WHERE e.first_name = 'Evan' AND e.last_name = 'Harris';
GO

-- =====================================================
-- 6. FINANCIAL & TRANSACTION QUERIES
-- =====================================================

PRINT '';
PRINT '6. FINANCIAL & TRANSACTION REPORTS';
PRINT '----------------------------------';
GO

-- Query 6.1: Calculate booking cost for specific reservation
PRINT '6.1 Calculate cost for booking 11-111-11191';
SELECT 
    c.first_name + ' ' + c.last_name AS 'Customer Name',
    rb.room_number AS 'Room',
    rt.room_type_name AS 'Room Type',
    rb.from_date AS 'Check-In',
    rb.to_date AS 'Check-Out',
    DATEDIFF(DAY, rb.from_date, rb.to_date) AS 'Nights',
    rt.price_usd AS 'Price per Night',
    (DATEDIFF(DAY, rb.from_date, rb.to_date) * rt.price_usd) AS 'Total Cost'
FROM room_booked rb
INNER JOIN customer c ON rb.customer_id = c.customer_id
INNER JOIN room r ON rb.room_number = r.room_number
INNER JOIN room_type rt ON r.room_type_id = rt.room_type_id
WHERE rb.booking_number = '11-111-11191';
GO

-- Query 6.2: Daily revenue summary
PRINT '6.2 Daily transaction summary';
SELECT 
    CAST(t.transaction_time AS DATE) AS 'Transaction Date',
    COUNT(*) AS 'Number of Transactions',
    SUM(rt.price_usd * DATEDIFF(DAY, rb.from_date, rb.to_date)) AS 'Total Revenue',
    AVG(rt.price_usd * DATEDIFF(DAY, rb.from_date, rb.to_date)) AS 'Average Booking Value'
FROM [transaction] t
INNER JOIN room_booked rb ON t.booking_number = rb.booking_number
INNER JOIN room r ON rb.room_number = r.room_number
INNER JOIN room_type rt ON r.room_type_id = rt.room_type_id
WHERE t.transaction_status_id = 'S2'  -- Settled transactions
GROUP BY CAST(t.transaction_time AS DATE)
ORDER BY CAST(t.transaction_time AS DATE) DESC;
GO

-- =====================================================
-- 7. BUSINESS INTELLIGENCE & ANALYTICAL QUERIES
-- =====================================================

PRINT '';
PRINT '7. BUSINESS INTELLIGENCE & ANALYTICS';
PRINT '------------------------------------';
GO

-- Query 7.1: Monthly booking trends
PRINT '7.1 Monthly booking trends';
SELECT 
    YEAR(from_date) AS 'Year',
    MONTH(from_date) AS 'Month',
    COUNT(*) AS 'Number of Bookings',
    AVG(DATEDIFF(DAY, from_date, to_date)) AS 'Average Stay (Days)',
    SUM(number_of_guests) AS 'Total Guests'
FROM room_booked
GROUP BY YEAR(from_date), MONTH(from_date)
ORDER BY YEAR(from_date) DESC, MONTH(from_date) DESC;
GO

-- Query 7.2: Most popular room types
PRINT '7.2 Most popular room types';
SELECT 
    rt.room_type_name AS 'Room Type',
    COUNT(*) AS 'Number of Bookings',
    AVG(DATEDIFF(DAY, rb.from_date, rb.to_date)) AS 'Avg Stay (Days)',
    SUM(rt.price_usd * DATEDIFF(DAY, rb.from_date, rb.to_date)) AS 'Total Revenue'
FROM room_booked rb
INNER JOIN room r ON rb.room_number = r.room_number
INNER JOIN room_type rt ON r.room_type_id = rt.room_type_id
GROUP BY rt.room_type_name
ORDER BY COUNT(*) DESC;
GO

-- Query 7.3: Employee tenure analysis
PRINT '7.3 Employee tenure analysis';
SELECT 
    department_name AS 'Department',
    COUNT(*) AS 'Total Employees',
    AVG(DATEDIFF(YEAR, hire_date, GETDATE())) AS 'Avg Tenure (Years)',
    MIN(DATEDIFF(YEAR, hire_date, GETDATE())) AS 'Min Tenure',
    MAX(DATEDIFF(YEAR, hire_date, GETDATE())) AS 'Max Tenure'
FROM employee e
INNER JOIN department d ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY AVG(DATEDIFF(YEAR, hire_date, GETDATE())) DESC;
GO

-- =====================================================
-- 8. DATA MAINTENANCE & UPDATE QUERIES
-- =====================================================

PRINT '';
PRINT '8. DATA MAINTENANCE & UPDATES';
PRINT '----------------------------';
GO

-- Query 8.1: Update room type pricing
PRINT '8.1 Increase Presidential suite price by $10';
UPDATE room_type
SET price_usd = price_usd + 10
WHERE room_type_name = 'Presidential suite';

-- Verify the update
SELECT room_type_name, price_usd 
FROM room_type 
WHERE room_type_name = 'Presidential suite';
GO

-- Query 8.2: Update room status after checkout
PRINT '8.2 Update room status to Vacant after checkout';
UPDATE room
SET room_status_id = 'S2'  -- Vacant
WHERE room_number IN (
    SELECT DISTINCT r.room_number
    FROM room r
    INNER JOIN room_booked rb ON r.room_number = rb.room_number
    WHERE rb.to_date < GETDATE()
    AND r.room_status_id = 'S1'  -- Currently Booked
);
GO

-- Query 8.3: Find duplicate customer records
PRINT '8.3 Potential duplicate customers';
SELECT 
    first_name,
    last_name,
    COUNT(*) AS duplicate_count
FROM customer
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;
GO

PRINT '';
PRINT '=== ALL SAMPLE QUERIES COMPLETED ===';
PRINT 'Total: 20 unique practical business queries';
PRINT 'Covering: Key Statistics, Room Management, Customer Service, Financial Reports, HR Analytics';
GO
