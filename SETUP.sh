#!/bin/bash

# ============================================
# Quick Setup Script for Google Login
# ============================================

echo "🚀 Google Login Setup for Android"
echo "=================================="

# Step 1: Flutter packages
echo "📦 Installing Flutter packages..."
cd flutter-auth-app
flutter pub get
flutter clean
flutter pub get

echo ""
echo "✅ Flutter packages installed!"

# Step 2: Backend packages
echo ""
echo "📦 Checking backend packages..."
cd ../backend-auth-api

# Check if jsonwebtoken is installed
if ! grep -q "jsonwebtoken" package.json; then
    echo "Installing jsonwebtoken..."
    npm install jsonwebtoken
else
    echo "✅ jsonwebtoken already installed"
fi

echo ""
echo "📋 Database Setup Instructions:"
echo "================================"
echo ""
echo "Run this SQL in your MySQL database:"
echo ""
echo "ALTER TABLE users ADD COLUMN provider VARCHAR(50) DEFAULT 'email';"
echo "ALTER TABLE users ADD COLUMN photoUrl VARCHAR(500) NULLABLE;"
echo ""
echo "Or import the file:"
echo "mysql -u root -p your_database < GOOGLE_AUTH_DATABASE.sql"
echo ""

echo ""
echo "🔑 Environment Variables:"
echo "========================"
echo ""
echo "Make sure your .env file has:"
echo "  JWT_SECRET=your_secret_key"
echo "  DB_HOST=localhost"
echo "  DB_USER=root"
echo "  DB_PASSWORD=your_password"
echo "  DB_NAME=your_database"
echo ""

echo ""
echo "✅ Setup Complete!"
echo "==================="
echo ""
echo "Next steps:"
echo "1. Update your database with the new columns"
echo "2. Restart your Node.js backend server"
echo "3. Run Android emulator or device"
echo "4. flutter run"
echo ""
echo "Test: Click 'Login with Google' on login screen"
