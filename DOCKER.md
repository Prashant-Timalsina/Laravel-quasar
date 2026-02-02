# Docker Setup Guide for Laravel-Quasar Project

This guide will help you run the Laravel-Quasar project using Docker.

## Prerequisites

- Docker (version 20.10 or later)
- Docker Compose (version 1.29 or later)
- Git

## Project Structure

```
├── backend/               # Laravel API backend
│   ├── Dockerfile        # Backend Docker image definition
│   └── docker/           # Backend configuration files
│       ├── nginx.conf    # Nginx configuration for backend
│       ├── php.ini       # PHP configuration
│       ├── supervisord.conf  # Supervisor configuration
│       └── www.conf      # PHP-FPM configuration
├── frontend/             # Quasar SPA frontend
│   ├── Dockerfile        # Frontend Docker image definition
│   └── docker/           # Frontend configuration files
│       └── nginx.conf    # Nginx configuration for frontend
├── docker-compose.yml    # Docker Compose orchestration
├── .env.docker          # Docker environment variables (template)
└── .dockerignore        # Docker ignore files
```

## Quick Start

### 1. Clone the repository (if not already done)

```bash
git clone <repository-url>
cd Laravel-quasar
```

### 2. Prepare environment file

```bash
# Copy the Docker environment template to .env in backend
cp .env.docker backend/.env

# Or update your existing .env with Docker-specific variables
```

### 3. Build and start containers

```bash
# Build images and start services
docker-compose up --build

# Or run in background
docker-compose up -d --build
```

### 4. Initialize database

In a new terminal, run:

```bash
# Run migrations
docker-compose exec backend php artisan migrate

# Seed the database (optional)
docker-compose exec backend php artisan db:seed
```

### 5. Access the application

- **Frontend (Quasar)**: http://localhost:80 (or http://localhost)
- **Backend (Laravel)**: http://localhost:8000/api

## Available Commands

### Start/Stop services

```bash
# Start services
docker-compose up

# Start services in background
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Execute commands in containers

```bash
# Run Artisan commands
docker-compose exec backend php artisan <command>

# Examples
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan db:seed
docker-compose exec backend php artisan tinker

# Run npm commands in frontend
docker-compose exec frontend npm <command>

# Access bash shell in backend
docker-compose exec backend sh

# Access bash shell in frontend
docker-compose exec frontend sh
```

## Environment Variables

### Backend (.env)

Key variables for Docker:

```dotenv
APP_ENV=local              # local, testing, production
APP_DEBUG=true            # Enable/disable debug mode
APP_URL=http://localhost:8000
DB_CONNECTION=sqlite      # Database type
SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,localhost:80
```

### Docker Compose

You can override ports by setting environment variables:

```bash
# Custom ports
BACKEND_PORT=8001 FRONTEND_PORT=3000 docker-compose up

# Or create a .env file in the project root:
BACKEND_PORT=8001
FRONTEND_PORT=3000
```

## Services

### Backend Service

- **Image**: PHP 8.2 FPM + Alpine
- **Port**: 8000 (default)
- **Services**: 
  - PHP-FPM for application code
  - Nginx reverse proxy
  - SQLite database
- **Volumes**:
  - `/app` - Application code
  - `/app/storage` - Application storage
  - `/app/bootstrap/cache` - Cache directory

### Frontend Service

- **Image**: Node 22 Alpine + Nginx
- **Port**: 80 (default)
- **Services**:
  - Quasar SPA served by Nginx
- **Volumes**:
  - `/app/src` - Source code
  - `/app/public` - Static assets

## Production Deployment

For production, modify `docker-compose.yml`:

1. **Disable volume mounts** (use built images only)
2. **Set environment variables**:
   ```yaml
   APP_ENV: production
   APP_DEBUG: 'false'
   ```
3. **Use a proper database** instead of SQLite
4. **Enable HTTPS** with a reverse proxy like Traefik

Example production override:

```yaml
services:
  backend:
    environment:
      APP_ENV: production
      APP_DEBUG: 'false'
    volumes: []  # Remove volumes for production
```

## Troubleshooting

### Port already in use

If ports are already in use:

```bash
# Find what's using the port
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use different ports
BACKEND_PORT=8001 FRONTEND_PORT=3000 docker-compose up
```

### Database connection issues

```bash
# Check if backend service is running
docker-compose ps

# View backend logs
docker-compose logs backend

# Verify database file exists
docker-compose exec backend ls -la /app/database.sqlite
```

### Clear cache and rebuild

```bash
# Stop services
docker-compose down

# Remove volumes (WARNING: This will delete data)
docker-compose down -v

# Rebuild and start
docker-compose up --build
```

### PHP extensions not loading

```bash
# Verify PHP extensions
docker-compose exec backend php -m

# Check PHP configuration
docker-compose exec backend php -i
```

## Development Workflow

### Hot reload frontend

The frontend service has volumes mounted for `src` and `public`. Changes will be reflected immediately in your browser.

### Backend file changes

For backend changes:
```bash
# The app volume is mounted, so PHP code changes are instant
# But if you install new packages, rebuild the image:

docker-compose down
docker-compose up --build
```

### Database migrations

```bash
# Create new migration
docker-compose exec backend php artisan make:migration <name>

# Run migrations
docker-compose exec backend php artisan migrate

# Rollback
docker-compose exec backend php artisan migrate:rollback
```

## Docker Image Details

### Backend Image Build Process

1. **Builder stage**: Compiles PHP dependencies, npm assets
2. **Production stage**: Lightweight final image with only runtime dependencies
3. **Total size**: ~300MB

### Frontend Image Build Process

1. **Builder stage**: Builds Quasar SPA with npm
2. **Production stage**: Nginx serving static files
3. **Total size**: ~50MB

## Networking

Both services communicate via the `laravel-quasar-network` bridge network:

- Backend accessible at: `http://backend:8000`
- Frontend accessible at: `http://frontend:80`

For frontend to API calls:
- Update `quasar.conf.js` axios configuration to use `http://backend:8000`

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Laravel Docker Guide](https://laravel.com/docs/deployment)
- [Quasar Documentation](https://quasar.dev/)

## Support

For issues or questions:

1. Check the troubleshooting section above
2. Review Docker logs: `docker-compose logs -f`
3. Verify image build: `docker-compose build --no-cache`
4. Check your environment configuration
