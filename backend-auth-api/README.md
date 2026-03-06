# Backend Authentication API

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Create Database

#### Option A: Using MySQL Command Line
```bash
mysql -u root -p < database.sql
```

#### Option B: Manual Setup
1. Open MySQL Workbench or MySQL CLI
2. Run the SQL commands from `database.sql`
3. Create the database and users table

### 3. Configure Database

Update `config/db.js` with your MySQL credentials:
```javascript
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',           // Your MySQL username
  password: 'root',       // Your MySQL password
  database: 'auth_db',
  // ...
});
```

### 4. Start the Server

```bash
npm start
```

For development with auto-restart:
```bash
npm run dev
```

Server will run at: http://localhost:5000

## API Endpoints

### Register
**POST** `/api/auth/register`

Request body:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "userId": 1,
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Login
**POST** `/api/auth/login`

Request body:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Get Current User (Protected)
**GET** `/api/auth/me`

Headers:
```
Authorization: Bearer <token>
```

Response:
```json
{
  "success": true,
  "message": "User authenticated",
  "user": {
    "id": 1,
    "email": "john@example.com",
    "name": "John Doe",
    "iat": 1234567890,
    "exp": 1234654290
  }
}
```

### Health Check
**GET** `/health`

Response:
```json
{
  "success": true,
  "message": "Server is running"
}
```

## Database Schema

### users table:
- `id` (INT, Primary Key, Auto Increment)
- `name` (VARCHAR 255, Not Null)
- `email` (VARCHAR 255, Not Null, Unique)
- `password` (VARCHAR 255, Not Null - hashed with bcrypt)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

## Environment Variables

Create a `.env` file (optional):
```
PORT=5000
JWT_SECRET=your_super_secret_key
NODE_ENV=development
```

## Notes

1. **Password Hashing**: Uses bcryptjs with 10 salt rounds
2. **JWT Token**: Valid for 7 days
3. **CORS**: Enabled for all origins (configure as needed)
4. **Database Pool**: 10 connection limit

## Troubleshooting

### MySQL Connection Error
- Ensure MySQL is running
- Check database credentials in `config/db.js`
- Verify database exists: `auth_db`

### Port Already in Use
- Change PORT in `.env` or code
- Or kill process: `lsof -ti:5000 | xargs kill -9`

### Password Mismatch
- Passwords are hashed with bcrypt
- Never store plain text passwords
