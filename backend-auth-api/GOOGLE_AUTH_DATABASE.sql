/**
 * Database Setup for Google Authentication
 * 
 * IMPORTANT: Update your MySQL database with Google authentication support
 * 
 * File: database.sql (Add this to your existing database)
 */

-- ==============================================
-- Update users table to support Google login
-- ==============================================

-- If provider column doesn't exist, add it
ALTER TABLE users ADD COLUMN provider VARCHAR(50) DEFAULT 'email' AFTER email;

-- If photoUrl column doesn't exist, add it (optional)
ALTER TABLE users ADD COLUMN photoUrl VARCHAR(500) NULLABLE AFTER provider;

-- ==============================================
-- Complete users table structure (if creating new)
-- ==============================================

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NULLABLE,
  provider VARCHAR(50) DEFAULT 'email', -- 'email' or 'google'
  photoUrl VARCHAR(500) NULLABLE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX idx_email ON users(email);

-- ==============================================
-- Example queries
-- ==============================================

-- Check if user exists by email
-- SELECT * FROM users WHERE email = 'user@gmail.com';

-- Insert new Google user
-- INSERT INTO users (name, email, provider, photoUrl, created_at)
-- VALUES ('John Doe', 'john@gmail.com', 'google', 'https://...', NOW());

-- Update user photo
-- UPDATE users SET photoUrl = 'https://new-photo.jpg' WHERE id = 1;

-- Get all Google login users
-- SELECT * FROM users WHERE provider = 'google';

-- ==============================================
-- Optional: If you want to store refresh tokens
-- ==============================================

CREATE TABLE refresh_tokens (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  token VARCHAR(500) UNIQUE NOT NULL,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
