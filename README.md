# Car Inspection Backend API

Backend API for the Car Inspection Application built with Node.js, Express, and MySQL.

## Prerequisites

Before running this application, make sure you have the following installed:

- **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
- **MySQL** (v8.0 or higher) - [Download here](https://dev.mysql.com/downloads/mysql/)
- **npm** (comes with Node.js)

## Installation

1. **Install Node.js dependencies:**
   ```bash
   npm install
   ```

2. **Set up MySQL database:**
   - Make sure MySQL is running
   - Run the database schema script:
     ```bash
     mysql -u root -p < ../database_schema.sql
     ```
   - This will create the `car_inspection_db` database and all required tables

3. **Configure environment variables:**
   - Copy `.env.example` to `.env`:
     ```bash
     copy .env.example .env
     ```
   - Update the `.env` file with your MySQL credentials:
     ```
     DB_HOST=localhost
     DB_USER=root
     DB_PASSWORD=your_mysql_password
     DB_NAME=car_inspection_db
     JWT_SECRET=your_secret_key_here
     ```

## Running the Application

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (Protected)

### Users
- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/inspectors` - Get all inspectors (Admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user

### Inspections
- `POST /api/inspections` - Create inspection request (Customer)
- `GET /api/inspections` - Get all inspections (role-based)
- `GET /api/inspections/:id` - Get inspection by ID
- `PUT /api/inspections/:id/assign` - Assign inspector (Admin)
- `PUT /api/inspections/:id/status` - Update status

### Reports
- `POST /api/reports` - Create/update inspection report (Inspector)
- `GET /api/reports/:inspectionId` - Get report by inspection ID
- `POST /api/reports/:id/upload` - Upload inspection images

## Project Structure

```
backend/
├── config/          # Configuration files
├── controllers/     # Request handlers
├── middleware/      # Custom middleware
├── models/          # Sequelize models
├── routes/          # API routes
├── uploads/         # Uploaded images
├── utils/           # Utility functions
├── .env             # Environment variables
├── server.js        # Entry point
└── package.json     # Dependencies
```

## Default Admin User

After running the database schema, you can create an admin user by registering with:
- Email: admin@carinspection.com
- Password: admin123
- Role: admin

## Technologies Used

- **Express.js** - Web framework
- **Sequelize** - ORM for MySQL
- **JWT** - Authentication
- **Bcrypt** - Password hashing
- **Multer** - File uploads
- **CORS** - Cross-origin resource sharing
