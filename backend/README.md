# Smart Card Backend API

Backend API for Smart Card application built with Node.js, Express, and MongoDB.

## Features

- ✅ User Authentication (Register, Login, OTP Verification)
- ✅ User Management
- ✅ Contacts Management
- ✅ Notes Management
- ✅ Follow-ups Management
- ✅ Leads Management (for Exhibitors)
- ✅ Requests Management
- ✅ Statistics API
- ✅ JWT Authentication
- ✅ Role-based Access Control (Visitor/Exhibitor)

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or MongoDB Atlas)
- npm or yarn

## Installation

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file (copy from `.env.example`):
```bash
cp .env.example .env
```

3. Update `.env` with your configuration:
```env
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/smartcard
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
```

## Running the Server

### Development Mode (with auto-reload):
```bash
npm run dev
```

### Production Mode:
```bash
npm start
```

The server will run on `http://localhost:3000` by default.

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/verify-otp` - Verify OTP
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user
- `POST /api/auth/resend-otp` - Resend OTP

### Users
- `GET /api/users/expo/:expoId` - Get user by SmartCard ID (public)
- `PUT /api/users/profile` - Update user profile

### Contacts (Visitor)
- `GET /api/contacts` - Get all contacts
- `GET /api/contacts/:id` - Get contact by ID
- `POST /api/contacts` - Create contact (scan QR)
- `PUT /api/contacts/:id` - Update contact
- `DELETE /api/contacts/:id` - Delete contact

### Notes (Visitor)
- `GET /api/notes` - Get all notes
- `GET /api/notes/contact/:contactId` - Get notes by contact
- `POST /api/notes` - Create note
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note

### Follow-ups (Visitor)
- `GET /api/followups` - Get all follow-ups
- `GET /api/followups/contact/:contactId` - Get follow-ups by contact
- `POST /api/followups` - Create follow-up
- `PUT /api/followups/:id` - Update follow-up
- `DELETE /api/followups/:id` - Delete follow-up

### Leads (Exhibitor)
- `GET /api/leads` - Get all leads
- `GET /api/leads/:id` - Get lead by ID
- `POST /api/leads` - Create lead (scan visitor QR)
- `PUT /api/leads/:id` - Update lead
- `PUT /api/leads/:id/status` - Update lead status

### Requests
- `GET /api/requests` - Get all requests (Exhibitor)
- `GET /api/requests/my-requests` - Get my requests (Visitor)
- `POST /api/requests` - Create request (Visitor)
- `PUT /api/requests/:id/status` - Update request status (Exhibitor)

### Statistics
- `GET /api/stats/exhibitor` - Get exhibitor statistics
- `GET /api/stats/visitor` - Get visitor statistics

## Authentication

Most endpoints require authentication. Include the JWT token in the Authorization header:

```
Authorization: Bearer <your-token>
```

## Project Structure

```
backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/             # Request handlers
│   ├── authController.js
│   ├── contactController.js
│   ├── noteController.js
│   ├── followUpController.js
│   ├── leadController.js
│   ├── requestController.js
│   ├── statsController.js
│   └── userController.js
├── middleware/
│   └── auth.js              # Authentication middleware
├── models/                   # MongoDB models
│   ├── User.js
│   ├── Contact.js
│   ├── Note.js
│   ├── FollowUp.js
│   ├── Lead.js
│   └── Request.js
├── routes/                   # API routes
│   ├── auth.js
│   ├── users.js
│   ├── contacts.js
│   ├── notes.js
│   ├── followups.js
│   ├── leads.js
│   ├── requests.js
│   └── stats.js
├── utils/
│   ├── generateToken.js
│   └── generateOTP.js
├── server.js                 # Main server file
├── package.json
└── README.md
```

## Environment Variables

- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Environment (development/production)
- `MONGODB_URI` - MongoDB connection string
- `JWT_SECRET` - Secret key for JWT tokens
- `JWT_EXPIRE` - JWT token expiration (default: 7d)
- `OTP_EXPIRE_MINUTES` - OTP expiration in minutes (default: 10)

## Notes

- OTP is currently logged to console. In production, integrate with SMS/Email service.
- AI Score calculation is simplified. In production, implement actual AI analysis.
- File uploads are not yet implemented. Add multer configuration for brochure uploads.

## Next Steps

1. Integrate SMS/Email service for OTP
2. Implement file upload for brochures
3. Add AI service integration for lead scoring
4. Add rate limiting
5. Add request validation middleware
6. Add logging service
7. Add unit and integration tests

