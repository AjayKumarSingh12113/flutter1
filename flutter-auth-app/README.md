# Flutter Authentication App

A clean, industry-level Flutter authentication system with Login, Register, and Dashboard screens.

## Features

- ✅ User Registration with validation
- ✅ User Login with JWT authentication  
- ✅ Form validation (email, password)
- ✅ API integration with Node.js backend
- ✅ Dashboard screen after successful login
- ✅ Responsive design (tested on Pixel 2)
- ✅ Error handling and loading states
- ✅ State management using Provider
- ✅ Clean folder structure
- ✅ Logout functionality

## Setup Instructions

### 1. Prerequisites

- Flutter SDK installed
- Dart SDK (comes with Flutter)
- A text editor or IDE (VS Code, Android Studio)

### 2. Clone/Setup Project

```bash
cd flutter-auth-app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Update Backend URL (if needed)

Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
```

- `10.0.2.2` is the Android emulator's address for localhost
- Use actual IP for physical device

### 5. Run the App

```bash
flutter run
```

Or for a specific device:
```bash
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── main.dart                          # Entry point
├── models/
│   └── user_model.dart                # User data model
├── services/
│   └── api_service.dart               # API calls
└── features/
    ├── auth/
    │   ├── screens/
    │   │   ├── login_screen.dart       # Login page
    │   │   └── register_screen.dart    # Registration page
    │   ├── controller/
    │   │   └── auth_controller.dart    # State management
    │   └── widgets/
    │       └── auth_textfield.dart     # Custom text field
    └── dashboard/
        └── screens/
            └── dashboard_screen.dart   # Home page after login
```

## Dependencies

- **provider**: ^6.0.0 - State management
- **http**: ^1.1.0 - API calls
- **cupertino_icons**: ^1.0.2 - iOS-style icons

## Screens

### Login Screen
- Email and password input fields
- Form validation
- Link to register screen
- Loading indicator during login
- Navigate to dashboard on success

### Register Screen
- Name, email, password, and confirm password fields
- Form validation
- Password match validation
- Auto navigate to login on success
- Link to login screen

### Dashboard Screen
- Display user information
- Show login status
- Logout button
- Responsive layout

## API Integration

The app uses the following API endpoints:

### Register
```
POST /api/auth/register
Body: {
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Login
```
POST /api/auth/login
Body: {
  "email": "john@example.com",
  "password": "password123"
}
Response: {
  "token": "jwt_token",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

## Validation Rules

### Email
- Must be provided
- Must be valid email format

### Password
- Must be provided
- Minimum 6 characters
- On register, must match confirm password

### Name
- Must be provided
- Minimum 2 characters

## Responsive Design

The app is tested and optimized for:
- Pixel 2 (small screen)
- Pixel 5 (medium screen)
- Galaxy Tab (large screen)

Uses MediaQuery for responsive sizing:
- Padding adapts to screen size
- Text scales appropriately
- Buttons are touch-friendly

## Error Handling

- Network error handling
- Validation errors shown below fields
- Error messages in snackbars
- Loading states during API calls
- Proper error messages from backend

## State Management

Using **Provider** package:
- `AuthController` manages login/register state
- Notifies UI of changes
- Stores user data and token
- Simple and clean implementation

## Testing

### Manual Testing
1. Test registration with valid data
2. Test registration with invalid email
3. Test password validation
4. Test login with correct credentials
5. Test login with wrong password
6. Test navigation flows
7. Test on different screen sizes

## Production Setup

1. Update API base URL
2. Implement secure token storage
3. Add deeper error logging
4. Implement refresh token mechanism
5. Add biometric authentication
6. Setup proper error reporting

## Troubleshooting

### API Connection Error
- Ensure backend server is running
- Check URL in `api_service.dart`
- Verify network connectivity

### Build Error
- Run `flutter clean`
- Run `flutter pub get`
- Check Flutter version

### Emulator Issues
- Use `10.0.2.2` for Android emulator
- Use `localhost` for iOS simulator

## License

MIT
