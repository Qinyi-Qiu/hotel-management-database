# Hotel Management Database System

**Author**: Qinyi Qiu  
**Date**: October 2023 (updated 2025 revision)  
**Technology**: Microsoft SQL Server

## Project Overview

A comprehensive relational database system designed for small-to-medium hotels, supporting core operations through a modular, normalized architecture.

## Database Architecture

### Modular Design

#### Employee Module (5 tables)
- **`role`**: Contains data about employee roles, including role ID and role name. Primary key: `role_id`.
- **`department`**: Contains data about departments, including department ID, name and manager ID. Primary key: `department_id`. Foreign key: `manager_id` has one-to-one relationship with Employee table.
- **`employee`**: Contains data about employees, including employee ID, name, gender, nationality, birthday, hire date, hourly salary and department ID. Primary key: `employee_id`. Foreign key: `department_id` has many-to-one relationship with Department table.
- **`employee_contact`**: Contains contact methods of employees, including employee ID, phone number, email and address. Primary key: `employee_id`. Foreign key: `employee_id` has one-to-one relationship with Employee table.
- **`employee_role`**: Contains role assignments for each employee, including employee ID, role ID, and start/end dates. Primary key: `employee_id`. Foreign keys: `employee_id` (one-to-one with Employee), `role_id` (many-to-one with Role).

#### Customer Module (4 tables)
- **`customer`**: Stores basic customer details including ID, name, gender, nationality, and date of birth. Primary key: `customer_id`. Has one-to-one relationship with Customer_Contact and one-to-many relationship with Room_Booked.
- **`customer_contact`**: Contains customer contact information, including customer ID, phone number, email address and living address. Primary key: `customer_id`. Foreign key: `customer_id` has one-to-one relationship with Customer table.
- **`membership_info`**: Contains membership type definitions, including membership code and name. Primary key: `membership_code`.
- **`membership`**: Contains customer membership records, including membership ID, code, customer ID, and start/end dates. Primary key: `membership_id`. Foreign key: `membership_code` has many-to-one relationship with Membership_Info table.

#### Room Module (4 tables)
- **`room_status`**: Contains room status definitions, including status ID and status name. Primary key: `room_status_id`.
- **`room_type`**: Contains room type definitions, including room type ID, name, max capacity and price. Primary key: `room_type_id`.
- **`room`**: Contains room inventory data, including room number, type ID, status, and accessibility features (pet-friendly, smoker-friendly, disability-friendly). Primary key: `room_number`. Foreign keys: `room_type_id` (many-to-one with Room_Type), `room_status_id` (many-to-one with Room_Status).
- **`room_booked`**: Contains booking records, including booking number, room number, customer ID, number of guests and stay dates. Primary key: `booking_number`. Foreign keys: `room_number` (one-to-one with Room), `customer_id` (many-to-one with Customer).

#### Transaction Module (3 tables)
- **`transaction_status`**: Contains transaction status definitions, including status ID and status name. Primary key: `transaction_status_id`.
- **`payment_method`**: Contains payment method definitions, including payment method ID and name. Primary key: `payment_method_id`.
- **`transaction`**: Contains financial transaction records, including transaction ID, booking number, employee ID, customer ID, payment method, status and timestamp. Primary key: `transaction_id`. Foreign keys: `booking_number` (many-to-one with Room_Booked), `employee_id` (many-to-one with Employee), `customer_id` (many-to-one with Customer), `payment_method_id` (many-to-one with Payment_Method).

### Key Specifications
- **Total Tables**: 16
- **Sample Records**: 628
- **Normalization**: 3NF compliant
- **Constraints**: 20+ (PK, FK, Check, Unique)

## Business Capabilities

### Operational Management
- Real-time room availability and status tracking
- Customer booking and check-in/check-out processes
- Staff scheduling and role management
- Membership program administration

### Financial Tracking
- Payment processing with multiple methods
- Revenue reporting and transaction history
- Booking cost calculations and invoicing

### Analytics & Reporting
- Occupancy rates and revenue analysis
- Customer demographics and preferences
- Staff performance and departmental metrics

## Technical Features

### Data Integrity
- Referential integrity through foreign keys
- Business rule enforcement with check constraints
- Unique constraints on critical fields (email, phone)

### Performance
- Strategic indexing on frequently queried columns
- Optimized join patterns for complex queries
- Efficient data types (BIT for flags, DECIMAL for monetary values)

### Views for Business Intelligence
- `Room_Info`: Complete room details
- `Departmental_Gender_Differences`: HR analytics
- `Customer_Nationalities`: Demographic insights
- `Booked_Customers`: Current guest overview

## Sample Business Insights

Based on the sample data:
- **Occupancy Rate**: 71.11% 
- **Popular Payment**: Credit Card (79.31%)
- **Member Distribution**: Silver (40%), Gold (35%), Platinum (25%)
- **International Guests**: 18 nationalities represented

## Implementation

### Project Structure
- `database_creation.sql` - Schema and constraints
- `insert_data.sql` - Sample data population  
- `sample_queries.sql` - Business queries and reports
- `README.md` - Project documentation
  
## Quick Start

1. Execute `database_creation.sql` to create schema
2. Run `insert_data.sql` to populate sample data
3. Use `sample_queries.sql` for business operations

## Future Enhancements

- Stored procedures for automated workflows
- Trigger-based audit logging
- Integration with web/mobile applications
- Advanced analytics and forecasting

## Conclusion
The Hotel Management Database System project served as my practical application following Google's course "Analysing Data to Answer Questions".
It demonstrates how relational database principles can be employed to organise and manage complex hotel operations.
