-- =====================================================
-- Hotel Management Database System
-- Database Creation Script
-- Author: Qinyi Qiu
-- Date: October 2023 (updated 2025 revision)
-- =====================================================

-- Drop database if exists (optional - uncomment if needed)
-- USE master;
-- GO
-- DROP DATABASE IF EXISTS hotel_management_database;
-- GO

-- Create database
CREATE DATABASE hotel_management_database;
GO

USE hotel_management_database;
GO

-- =====================================================
-- 1. EMPLOYEE MODULE
-- =====================================================

-- Role table
CREATE TABLE role (
    role_id VARCHAR(10) NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (role_id),
    UNIQUE (role_name)
);
GO

-- Department table
CREATE TABLE department (
    department_id INT NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    manager_id INT NULL, -- Will be set after employee table creation
    PRIMARY KEY (department_id),
    UNIQUE (department_name)
);
GO

-- Employee table
CREATE TABLE employee (
    employee_id INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    hourly_salary_usd DECIMAL(10,2) NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    UNIQUE (first_name, last_name)
);
GO

-- Employee Contact table
CREATE TABLE employee_contact (
    employee_id INT NOT NULL,
    employee_phone_number VARCHAR(255) NOT NULL,
    employee_email VARCHAR(255) NOT NULL,
    employee_address VARCHAR(255) NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    UNIQUE (employee_phone_number),
    UNIQUE (employee_email)
);
GO

-- Employee Role table
CREATE TABLE employee_role (
    employee_id INT NOT NULL,
    role_id VARCHAR(10) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);
GO

-- =====================================================
-- 2. CUSTOMER MODULE
-- =====================================================

-- Customer table
CREATE TABLE customer (
    customer_id INT NOT NULL,
    username VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    birth_date DATE NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id),
    UNIQUE (username),
    UNIQUE (first_name, last_name)
);
GO

-- Customer Contact table
CREATE TABLE customer_contact (
    customer_id INT NOT NULL,
    customer_phone_number VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_address VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    UNIQUE (customer_phone_number),
    UNIQUE (customer_email)
);
GO

-- Membership Info table
CREATE TABLE membership_info (
    membership_code VARCHAR(10) NOT NULL,
    membership_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (membership_code),
    UNIQUE (membership_name)
);
GO

-- Membership table
CREATE TABLE membership (
    membership_id INT NOT NULL,
    membership_code VARCHAR(10) NOT NULL,
    customer_id INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (membership_id),
    FOREIGN KEY (membership_code) REFERENCES membership_info(membership_code),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
GO

-- =====================================================
-- 3. ROOM MODULE
-- =====================================================

-- Room Status table
CREATE TABLE room_status (
    room_status_id VARCHAR(10) NOT NULL,
    room_status_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (room_status_id),
    UNIQUE (room_status_name)
);
GO

-- Room Type table
CREATE TABLE room_type (
    room_type_id VARCHAR(10) NOT NULL,
    room_type_name VARCHAR(255) NOT NULL,
    max_capacity INT NOT NULL,
    price_usd DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (room_type_id),
    UNIQUE (room_type_name)
);
GO

-- Room table
CREATE TABLE room (
    room_number VARCHAR(10) NOT NULL,
    room_type_id VARCHAR(10) NOT NULL,
    room_status_id VARCHAR(10) NOT NULL,
    is_pet_friendly BIT NOT NULL,
    is_smoker_friendly BIT NOT NULL,
    is_disability_friendly BIT NOT NULL,
    PRIMARY KEY (room_number),
    FOREIGN KEY (room_status_id) REFERENCES room_status(room_status_id),
    FOREIGN KEY (room_type_id) REFERENCES room_type(room_type_id)
);
GO

-- Room Booked table
CREATE TABLE room_booked (
    booking_number CHAR(12) NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    customer_id INT NOT NULL,
    number_of_guests INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (booking_number),
    FOREIGN KEY (room_number) REFERENCES room(room_number),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
GO

-- =====================================================
-- 4. TRANSACTION MODULE
-- =====================================================

-- Transaction Status table
CREATE TABLE transaction_status (
    transaction_status_id VARCHAR(10) NOT NULL,
    transaction_status_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (transaction_status_id),
    UNIQUE (transaction_status_name)
);
GO

-- Payment Method table
CREATE TABLE payment_method (
    payment_method_id VARCHAR(10) NOT NULL,
    payment_method_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (payment_method_id),
    UNIQUE (payment_method_name)
);
GO

-- Transaction table
CREATE TABLE [transaction] (
    transaction_id CHAR(18) NOT NULL,
    booking_number CHAR(12) NOT NULL,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    payment_method_id VARCHAR(10) NOT NULL,
    transaction_status_id VARCHAR(10) NOT NULL,
    transaction_time DATE NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (booking_number) REFERENCES room_booked(booking_number),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id),
    FOREIGN KEY (transaction_status_id) REFERENCES transaction_status(transaction_status_id)
);
GO

-- =====================================================
-- ADD CIRCULAR DEPENDENCY CONSTRAINTS
-- =====================================================

-- Add manager foreign key to department table (depends on employee table)
ALTER TABLE department
ADD CONSTRAINT fk_department_manager 
FOREIGN KEY (manager_id) REFERENCES employee(employee_id);
GO

-- =====================================================
-- ADD BUSINESS LOGIC CONSTRAINTS
-- =====================================================

-- Check constraint for Room_Booked dates
ALTER TABLE room_booked
ADD CONSTRAINT chk_staying_time 
CHECK (from_date <= to_date);
GO

-- Check constraint for Employee_Role dates
ALTER TABLE employee_role
ADD CONSTRAINT chk_employee_role_time 
CHECK (from_date <= to_date);
GO

-- Check constraint for Membership dates
ALTER TABLE membership
ADD CONSTRAINT chk_membership_dates 
CHECK (from_date <= to_date);
GO

-- =====================================================
-- ADD PERFORMANCE INDEXES
-- =====================================================

-- Employee module indexes
CREATE INDEX idx_employee_department ON employee(department_id);
CREATE INDEX idx_employee_name ON employee(first_name, last_name);
GO

-- Customer module indexes
CREATE INDEX idx_customer_names ON customer(first_name, last_name);
CREATE INDEX idx_customer_nationality ON customer(nationality);
GO

-- Room module indexes
CREATE INDEX idx_room_booked_dates ON room_booked(from_date, to_date);
CREATE INDEX idx_room_booked_customer ON room_booked(customer_id);
CREATE INDEX idx_room_type_price ON room_type(price_usd);
GO

-- Transaction module indexes
CREATE INDEX idx_transaction_time ON [transaction](transaction_time);
CREATE INDEX idx_transaction_customer ON [transaction](customer_id);
CREATE INDEX idx_transaction_employee ON [transaction](employee_id);
GO

PRINT 'Hotel Management Database created successfully!';
PRINT 'All modules (Employee, Customer, Room, Transaction) have been created.';
PRINT 'Tables: 16, Constraints: 20+, Indexes: 10+';
