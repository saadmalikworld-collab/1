# Car Inspection Web Application

A full-stack web application for managing car inspection services with customer requests, inspector assignments, and comprehensive inspection reports.

## 🚀 Features

- **User Authentication**: JWT-based authentication with role-based access control
- **Three User Roles**: Customer, Inspector, and Admin portals
- **Inspection Management**: Complete CRUD operations for inspection requests
- **Vehicle Details**: Comprehensive vehicle information tracking
- **Inspector Assignment**: Admin can assign inspectors to requests
- **Status Tracking**: Real-time inspection status updates
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Premium UI**: Modern dark theme with smooth animations

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
- **MySQL** (v8.0 or higher) - [Download](https://dev.mysql.com/downloads/mysql/)
- **npm** (comes with Node.js)

## 🛠️ Installation

### 1. Clone or Download the Project

Navigate to the project directory:
```bash
cd car-inspection-app
```

### 2. Set Up the Database

1. Make sure MySQL is running
2. Run the database schema script:
   ```bash
   mysql -u root -p < database_schema.sql
   ```
   This creates the `car_inspection_db` database and all required tables

### 3. Set Up the Backend

```bash
cd backend
npm install
```

Create a `.env` file by copying `.env.example`:
```bash
copy .env.example .env
```

Update the `.env` file with your MySQL credentials:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=car_inspection_db
JWT_SECRET=your_secret_key_here
```

### 4. Set Up the Frontend

```bash
cd ../frontend
npm install
```

## 🚀 Running the Application

### Start the Backend Server

```bash
cd backend
npm run dev
```

The backend will run on `http://localhost:5000`

### Start the Frontend Application

In a new terminal:

```bash
cd frontend
npm run dev
```

The frontend will run on `http://localhost:3000`

## 👥 User Roles & Access

### Customer
- Create inspection requests
- View own inspection requests and reports
- Track inspection status

### Inspector
- View assigned inspections
- Update inspection status
- Complete inspection reports

### Admin
- View all inspections
- Assign inspectors to requests
- Manage users
- View system statistics

## 📁 Project Structure

```
car-inspection-app/
├── database_schema.sql          # MySQL database schema
├── backend/                     # Node.js + Express backend
│   ├── config/                  # Configuration files
│   ├── controllers/             # Request handlers
│   ├── middleware/              # Auth, upload, role middleware
│   ├── models/                  # Sequelize models
│   ├── routes/                  # API routes
│   ├── uploads/                 # Uploaded images
│   ├── server.js                # Entry point
│   └── package.json
└── frontend/                    # React + Vite frontend
    ├── src/
    │   ├── components/          # React components
    │   ├── context/             # Auth context
    │   ├── services/            # API services
    │   ├── App.jsx              # Main app component
    │   └── index.css            # Global styles
    ├── index.html
    └── package.json
```

## 🔑 Default Test Accounts

After setting up the database, you can create test accounts:

**Admin Account:**
- Register at `/register` with role: admin
- Or use the SQL insert in `database_schema.sql`

**Inspector Account:**
- Register at `/register` with role: inspector

**Customer Account:**
- Register at `/register` with role: customer (default)

## 🎨 Technology Stack

### Backend
- Node.js + Express.js
- MySQL + Sequelize ORM
- JWT Authentication
- Bcrypt for password hashing
- Multer for file uploads

### Frontend
- React 18
- Vite
- React Router v6
- Axios
- React Toastify
- Custom CSS with design system

## 📝 API Endpoints

### Authentication
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Inspections
- `POST /api/inspections` - Create inspection
- `GET /api/inspections` - Get all inspections
- `GET /api/inspections/:id` - Get inspection by ID
- `PUT /api/inspections/:id/assign` - Assign inspector
- `PUT /api/inspections/:id/status` - Update status

### Reports
- `POST /api/reports` - Create/update report
- `GET /api/reports/:inspectionId` - Get report
- `POST /api/reports/:id/upload` - Upload images

## 🐛 Troubleshooting

### Backend won't start
- Check if MySQL is running
- Verify database credentials in `.env`
- Ensure port 5000 is not in use

### Frontend won't start
- Ensure Node.js is installed
- Run `npm install` in the frontend directory
- Check if port 3000 is available

### Database connection errors
- Verify MySQL is running
- Check database credentials
- Ensure `car_inspection_db` database exists

## 📄 License

This project is for educational and commercial use.

## 🤝 Support

For issues or questions, please refer to the documentation in each directory's README file.
