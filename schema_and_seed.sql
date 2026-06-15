-- MEDCARE DENTAL CLINIC DATABASE SCHEMA & SEED DATA
-- Target DB: appointmentdb
-- Target DBMS: PostgreSQL

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS roles (
    role BIGINT PRIMARY KEY,
    rolename VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS menus (
    mid BIGINT PRIMARY KEY,
    menu VARCHAR(100) NOT NULL,
    micon VARCHAR(100)
);

-- Note: rolesmapping table mapping menus to roles
CREATE TABLE IF NOT EXISTS rolesmapping (
    id SERIAL PRIMARY KEY,
    mid BIGINT,
    role BIGINT
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role INT,
    status INT
);

CREATE TABLE IF NOT EXISTS time_slot (
    id SERIAL PRIMARY KEY,
    provider_name VARCHAR(150) NOT NULL,
    slot_date VARCHAR(50) NOT NULL,
    start_time VARCHAR(20) NOT NULL,
    end_time VARCHAR(20) NOT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS appointment (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    slot_id BIGINT,
    booking_date VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- 2. Seed Data
-- Seed Roles
INSERT INTO roles (role, rolename) VALUES
(1, 'PATIENT'),
(2, 'DENTIST'),
(3, 'ADMIN')
ON CONFLICT (role) DO NOTHING;

-- Seed Menus
INSERT INTO menus (mid, menu, micon) VALUES
(1, 'Dashboard', 'DashboardIcon'),
(2, 'Dentists', 'DentistIcon'),
(3, 'Book Appointment', 'BookIcon'),
(4, 'My Appointments', 'CalendarIcon'),
(5, 'Manage Users', 'UsersIcon')
ON CONFLICT (mid) DO NOTHING;

-- Seed Roles Mapping (RBAC configuration)
-- Patient can access Dashboard (1), Dentists (2), Book Appointment (3), My Appointments (4)
INSERT INTO rolesmapping (mid, role) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),
-- Dentist can access Dashboard (1), Dentists (2), My Appointments (4)
(1, 2), (2, 2), (4, 2),
-- Admin can access all menus
(1, 3), (2, 3), (3, 3), (4, 3), (5, 3)
ON CONFLICT DO NOTHING;

-- Seed initial Users
-- Admin User: admin@medcare.com / admin123
INSERT INTO users (id, fullname, phone, email, password, role, status) VALUES
(nextval('users_seq'), 'Medcare Admin', '1234567890', 'admin@medcare.com', 'admin123', 3, 1)
ON CONFLICT (email) DO NOTHING;

