/**
 * Google Authentication Controller
 * Handles Google login requests from Flutter app
 * 
 * File: controllers/googleAuthController.js
 */

const db = require('../config/db');
const jwt = require('jsonwebtoken');

/**
 * Google Login Handler
 * POST /api/auth/google-login
 * 
 * Request Body:
 * {
 *   "email": "user@gmail.com",
 *   "name": "User Name",
 *   "photo": "https://..."
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "message": "Google login successful",
 *   "token": "JWT_TOKEN",
 *   "user": {
 *     "id": 1,
 *     "name": "User Name",
 *     "email": "user@gmail.com"
 *   }
 * }
 */
exports.googleLogin = async (req, res) => {
  const connection = await db.getConnection();
  try {
    const { email, name, photo } = req.body;

    // Validation
    if (!email || !name) {
      return res.status(400).json({
        success: false,
        message: 'Email and name are required',
      });
    }

    // Check if user already exists
    const checkUserQuery = 'SELECT * FROM users WHERE email = ?';
    const [existingUsers] = await connection.execute(checkUserQuery, [email]);

    // User exists
    if (existingUsers.length > 0) {
      const user = existingUsers[0];

      // Generate JWT Token
      const token = jwt.sign(
        {
          id: user.id,
          email: user.email,
        },
        process.env.JWT_SECRET || 'your_secret_key',
        { expiresIn: '7d' }
      );

      // Return success response
      return res.status(200).json({
        success: true,
        message: 'Google login successful',
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
        },
      });
    }

    // User does not exist - Create new user
    const insertUserQuery =
      'INSERT INTO users (name, email, provider, created_at) VALUES (?, ?, ?, NOW())';

    const [insertResults] = await connection.execute(insertUserQuery, [
      name,
      email,
      'google',
    ]);

    // Get the newly created user ID
    const userId = insertResults.insertId;

    // Generate JWT Token
    const token = jwt.sign(
      {
        id: userId,
        email: email,
      },
      process.env.JWT_SECRET || 'your_secret_key',
      { expiresIn: '7d' }
    );

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Google login successful - New user created',
      token,
      user: {
        id: userId,
        name: name,
        email: email,
      },
    });
  } catch (error) {
    console.error('Google login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error during Google login',
      error: error.message,
    });
  } finally {
    connection.release();
  }
};

/**
 * Alternative: If you want to update photo for existing users
 */
exports.googleLoginWithPhoto = (req, res) => {
  try {
    const { email, name, photo } = req.body;

    if (!email || !name) {
      return res.status(400).json({
        success: false,
        message: 'Email and name are required',
      });
    }

    const checkUserQuery = 'SELECT * FROM users WHERE email = ?';

    db.query(checkUserQuery, [email], (error, results) => {
      if (error) {
        console.error('Database error:', error);
        return res.status(500).json({
          success: false,
          message: 'Database error',
        });
      }

      // User exists - Update if photo is provided
      if (results.length > 0) {
        const user = results[0];

        // Update photo if provided
        if (photo) {
          const updatePhotoQuery = 'UPDATE users SET photoUrl = ? WHERE id = ?';
          db.query(updatePhotoQuery, [photo, user.id], (updateError) => {
            if (updateError) {
              console.error('Error updating photo:', updateError);
            }
          });
        }

        const token = jwt.sign(
          {
            id: user.id,
            email: user.email,
          },
          process.env.JWT_SECRET || 'your_secret_key',
          { expiresIn: '7d' }
        );

        return res.status(200).json({
          success: true,
          message: 'Google login successful',
          token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
          },
        });
      }

      // Create new user with photo
      const insertUserQuery =
        'INSERT INTO users (name, email, photoUrl, provider, created_at) VALUES (?, ?, ?, ?, NOW())';

      db.query(
        insertUserQuery,
        [name, email, photo || null, 'google'],
        (insertError, insertResults) => {
          if (insertError) {
            console.error('Error creating user:', insertError);
            return res.status(500).json({
              success: false,
              message: 'Error creating user',
            });
          }

          const userId = insertResults.insertId;

          const token = jwt.sign(
            {
              id: userId,
              email: email,
            },
            process.env.JWT_SECRET || 'your_secret_key',
            { expiresIn: '7d' }
          );

          return res.status(201).json({
            success: true,
            message: 'Google login successful - New user created',
            token,
            user: {
              id: userId,
              name: name,
              email: email,
            },
          });
        }
      );
    });
  } catch (error) {
    console.error('Google login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error during Google login',
    });
  }
};
