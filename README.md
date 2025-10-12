# Hotel Management Database System

**Author:** Qinyi Qiu  
**Date:** October 2023 (updated 2025 revision)  
**Tech:** Microsoft SQL Server, SSMS

## Overview
Relational database design and implementation for a small-to-medium hotel.  
Supports core modules: Customers, Rooms, Bookings, Employees, Transactions, Membership.

## Contents
- `database_creation.sql` — CREATE TABLE statements and constraints (schema).
- `insert_data.sql` — Sample data to populate tables for testing.
- `sample_queries.sql` — Sample SQL queries for testing.
- `schema_diagram.pdf` — ER diagram.
- `report.pdf` — Full project report and explanation.

## How to run
1. Open SQL Server Management Studio (SSMS).  
2. Create a new database (e.g., `HotelManagementDB`).  
3. Run `database_creation.sql` in the context of that database.  
4. Run `insert_data.sql` to populate sample data.

## Notes & Improvements
- Consider adding stored procedures for booking logic and triggers for automated room status updates.
- Future: add transaction logging, user authentication layer, and Power BI reports.
