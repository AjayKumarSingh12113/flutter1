-- MySQL Database Setup

-- Create database
CREATE DATABASE IF NOT EXISTS auth_practice;
USE auth_practice;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email)
);

-- Example user (password: password123)
-- INSERT INTO users (name, email, password) VALUES (
--   'John Doe',
--   'john@example.com',
--   '$2a$10$...' -- bcrypt hashed password
-- );
