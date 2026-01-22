# Notes App

A full-stack web application for creating, managing, and organizing personal notes. Built with Laravel backend and Quasar Vue 3 frontend.

## 📋 Project Overview

Notes App is a notes management system that allows users to:

- Register and authenticate securely
- Create, read, update, and delete personal notes
- Manage multiple sessions with logout options
- Access notes from any device with an internet connection

The application uses **Laravel 12** with **Sanctum** for API authentication on the backend and **Quasar Framework** with **Vue 3** on the frontend.

## 🏗️ Architecture

```
Notes/
├── backend/          # Laravel API Server
├── frontend/         # Quasar Vue 3 SPA
└── README.md         # This file
```

### Backend Stack

- **Framework:** Laravel 12
- **Authentication:** Laravel Sanctum
- **Database:** MySQL/PostgreSQL (configurable)
- **ORM:** Eloquent
- **Build Tool:** Vite

### Frontend Stack

- **Framework:** Quasar 2 with Vue 3
- **State Management:** Pinia
- **HTTP Client:** Axios
- **Build Tool:** Vite
- **Styling:** Tailwind CSS

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v20 or higher)
- **npm** or **yarn**
- **PHP** (v8.2 or higher)
- **Composer**
- **SQLite** (or MySQL/PostgreSQL for production)

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/Prashant-Timalsina/Laravel-quasar.git
cd Notes
```

#### 2. Backend Setup

Navigate to the backend directory and set up the Laravel application:

```bash
cd backend

# Install PHP dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Run database migrations
php artisan migrate

# (Optional) Seed the database
php artisan db:seed

# Install Node.js dependencies
npm install
```

#### 3. Frontend Setup

Navigate to the frontend directory and set up the Quasar application:

```bash
cd ../frontend

# Install dependencies
npm install
```

## 📖 Development

### Running Both Frontend and Backend

#### Option 1: Run Separately

**Terminal 1 - Backend:**

```bash
cd backend
npm run dev
```

This will start:

- Laravel development server on `http://localhost:8000`
- Queue listener
- Vite asset server
- Log streaming

**Terminal 2 - Frontend:**

```bash
cd frontend
npm run dev
```

This will start:

- Quasar dev server on `http://localhost:9000` (or another available port)

#### Option 2: Run Concurrently (if using the setup script)

From the backend directory:

```bash
npm run dev
```

This runs both Laravel and Quasar dev servers concurrently.

### Backend Development

Navigate to `backend/` directory:

```bash
# Start development server
php artisan serve

# Run migrations
php artisan migrate

# Run database seeder
php artisan db:seed

# Create a new migration
php artisan make:migration <migration_name>

# Run tests
npm test

# Format code
php artisan pint

# Generate IDE helpers
php artisan ide-helper:generate
```

### Frontend Development

Navigate to `frontend/` directory:

```bash
# Start development server
npm run dev

# Lint files
npm run lint

# Format files
npm run format

# Build for production
npm run build
```

## 📚 API Documentation

### Base URL

```
http://localhost:8000/api
```

### Authentication Routes (Public)

#### Register

```http
POST /register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

#### Login

```http
POST /login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response includes:** `token`, `user` object

### Protected Routes

_Require `Authorization: Bearer {token}` header_

#### Get Current User

```http
GET /me
Authorization: Bearer {token}
```

#### Logout (Current Device)

```http
POST /logout
Authorization: Bearer {token}
```

#### Logout (All Devices)

```http
POST /logout-all
Authorization: Bearer {token}
```

### Notes Management (CRUD)

#### List All Notes

```http
GET /notes
Authorization: Bearer {token}
```

#### Create Note

```http
POST /notes
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "My First Note",
  "content": "This is the note content"
}
```

#### Get Note

```http
GET /notes/{id}
Authorization: Bearer {token}
```

#### Update Note

```http
PUT /notes/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Updated Title",
  "content": "Updated content"
}
```

#### Delete Note

```http
DELETE /notes/{id}
Authorization: Bearer {token}
```

### Admin/Debug Routes

#### List All Users

```http
GET /users
Authorization: Bearer {token}
```

For full API documentation, see [backend/Routes.md](./backend/Routes.md).

## 🗄️ Database Schema

### Users Table

- `id` - Primary key
- `name` - User's display name
- `email` - User's email (unique)
- `password` - Hashed password
- `created_at`, `updated_at` - Timestamps

### Notes Table

- `id` - Primary key
- `user_id` - Foreign key to users table
- `title` - Note title
- `note` - Note content
- `created_at`, `updated_at` - Timestamps

### Personal Access Tokens Table

- Used by Laravel Sanctum for API authentication
- Stores user tokens for session management

## 🔧 Configuration

### Backend Configuration

Edit `backend/.env` to configure:

```env
APP_NAME=Notes
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=notes_db
# DB_USERNAME=root
# DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost:9000
SESSION_DOMAIN=localhost
```

### Frontend Configuration

Edit `frontend/src/` config files as needed. The API base URL should be configured in the axios setup.

## 📦 Building for Production

### Backend

```bash
cd backend

# Install production dependencies
composer install --no-dev

# Optimize application
php artisan optimize

# Generate IDE helpers (optional)
php artisan ide-helper:generate

# Create build for deployment
# Follow your hosting provider's instructions
```

### Frontend

```bash
cd frontend

# Build for production
npm run build

# Output will be in dist/ folder
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/ExampleTest.php

# Run with coverage
php artisan test --coverage
```

### Frontend Tests

```bash
cd frontend

# Currently no tests configured
npm test
```

## 📁 Project Structure

### Backend (`backend/`)

```
app/
├── Http/
│   ├── Controllers/        # API Controllers
│   └── Requests/           # Form Requests
├── Models/
│   ├── User.php           # User model
│   └── Note.php           # Note model
└── Policies/
    └── NotePolicy.php     # Authorization policies

database/
├── migrations/            # Database migrations
├── seeders/              # Database seeders
└── factories/            # Model factories

routes/
├── api.php               # API routes
├── web.php               # Web routes
└── console.php           # Console commands

resources/
├── views/                # Blade templates
└── css/                  # Stylesheets

tests/                    # Test suites
```

### Frontend (`frontend/`)

```
src/
├── App.vue               # Root component
├── pages/                # Page components
├── components/           # Reusable components
├── layouts/              # Layout components
├── router/               # Vue Router configuration
├── stores/               # Pinia stores
├── assets/               # Static assets
├── boot/                 # Boot files
├── css/                  # Stylesheets
└── js/                   # JavaScript utilities

public/                   # Public assets
├── icons/                # App icons
└── index.html            # HTML template
```

## 🔐 Security Features

- **Password Hashing:** Laravel's bcrypt password hashing
- **API Authentication:** Laravel Sanctum tokens
- **Authorization:** Laravel policies for note ownership
- **CORS:** Configured for frontend domain
- **SQL Injection:** Protected via Eloquent ORM
- **CSRF Protection:** Built-in Laravel protection

## 🐛 Troubleshooting

### Backend Issues

**Port already in use:**

```bash
php artisan serve --port=8001
```

**Database connection error:**

- Ensure database credentials in `.env` are correct
- Run migrations: `php artisan migrate`

**Sanctum not working:**

- Ensure `SANCTUM_STATEFUL_DOMAINS` in `.env` matches your frontend domain

### Frontend Issues

**API calls failing:**

- Ensure backend is running on `http://localhost:8000`
- Check browser console for CORS errors
- Verify authorization token is being sent correctly

**Port conflict:**

```bash
quasar dev -p 9001
```

## 📝 Environment Variables

### Backend (.env)

- `APP_ENV` - Application environment (local, production)
- `APP_DEBUG` - Enable/disable debug mode
- `DB_*` - Database configuration
- `SANCTUM_STATEFUL_DOMAINS` - Frontend domains
- `MAIL_*` - Email configuration (optional)

### Frontend (.env)

- `VITE_API_URL` - Backend API URL (if needed)

## 🚢 Deployment

### Backend Deployment

Choose your hosting provider (e.g., Laravel Forge, Heroku, AWS):

1. Upload code via Git
2. Install dependencies: `composer install`
3. Configure `.env` with production settings
4. Run migrations: `php artisan migrate`
5. Set up HTTPS/SSL certificate
6. Configure web server (Nginx/Apache)

### Frontend Deployment

Deploy the `dist/` folder from the build:

1. Run `npm run build` in frontend directory
2. Upload `dist/` contents to your static hosting (Vercel, Netlify, AWS S3)
3. Configure environment to point to production API URL

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 👤 Author

**Prashant Timalsina**

- Email: prashanttimalsina2@gmail.com
- GitHub: [@Prashant-Timalsina](https://github.com/Prashant-Timalsina)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, please open an issue on the [GitHub repository](https://github.com/Prashant-Timalsina/Laravel-quasar/issues).

---

**Happy note-taking! ✍️**
