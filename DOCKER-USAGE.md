# Docker Deployment Guide

This document explains how to use the Docker setup for the Laravel-Quasar project.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture](#architecture)
3. [Configuration](#configuration)
4. [Usage](#usage)
5. [Development](#development)
6. [Production](#production)
7. [Troubleshooting](#troubleshooting)

## Quick Start

### Prerequisites
- Docker >= 20.10
- Docker Compose >= 1.29

### Setup (3 steps)

1. **Clone and navigate to project**
   ```bash
   git clone <repo-url>
   cd Laravel-quasar
   ```

2. **Copy environment file**
   ```bash
   cp .env.docker backend/.env
   ```

3. **Build and start**
   ```bash
   docker-compose up --build -d
   docker-compose exec backend php artisan migrate
   ```

4. **Access the app**
   - Frontend: http://localhost
   - Backend API: http://localhost:8000/api

## Architecture

### Services

**Backend Service**
- PHP 8.2 FPM on Alpine Linux
- Nginx reverse proxy
- SQLite database
- Port: 8000

**Frontend Service**
- Node.js 22 on Alpine Linux
- Nginx (production) / Vite dev server (development)
- Port: 80

### Network
- Both services communicate via Docker network `laravel-quasar-network`
- Frontend makes API calls to `http://backend:8000`

### Volumes

**Backend**
```
./backend/:/app                    - Source code
./backend/storage:/app/storage     - Files, logs
./backend/bootstrap/cache:/app/bootstrap/cache - Cache
```

**Frontend**
```
./frontend/src:/app/src            - Vue components
./frontend/public:/app/public      - Static assets
```

## Configuration

### Environment Variables

**Backend (.env)**
```dotenv
APP_ENV=local                          # Environment
APP_DEBUG=true                         # Debug mode
APP_URL=http://localhost:8000          # Base URL
DB_CONNECTION=sqlite                   # Database
SANCTUM_STATEFUL_DOMAINS=localhost     # CORS domains
```

**Docker Compose (.env or CLI)**
```bash
BACKEND_PORT=8000      # Backend port
FRONTEND_PORT=80       # Frontend port
```

### Set Custom Ports

```bash
# Via environment variables
BACKEND_PORT=8001 FRONTEND_PORT=3000 docker-compose up

# Via .env file in project root
echo "BACKEND_PORT=8001" >> .env
echo "FRONTEND_PORT=3000" >> .env
docker-compose up
```

## Usage

### Common Commands

```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f
docker-compose logs -f backend
docker-compose logs -f frontend

# Stop services
docker-compose stop

# Restart services
docker-compose restart

# Stop and remove containers
docker-compose down

# Remove containers and volumes (WARNING: deletes data)
docker-compose down -v
```

### Laravel Commands

```bash
# Database migrations
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan migrate:refresh
docker-compose exec backend php artisan migrate:rollback

# Database seeding
docker-compose exec backend php artisan db:seed

# Tinker console
docker-compose exec backend php artisan tinker

# Generate IDE helpers
docker-compose exec backend php artisan ide-helper:generate

# Clear caches
docker-compose exec backend php artisan cache:clear
docker-compose exec backend php artisan config:clear
docker-compose exec backend php artisan view:clear

# Create migration/model
docker-compose exec backend php artisan make:migration <name>
docker-compose exec backend php artisan make:model <name>
docker-compose exec backend php artisan make:controller <name>
```

### Shell Access

```bash
# Backend shell
docker-compose exec backend sh

# Frontend shell
docker-compose exec frontend sh

# Run commands
docker-compose exec backend composer install
docker-compose exec frontend npm install
```

## Development

### Development Stack

Use the development compose file for enhanced development experience:

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

**Features:**
- Hot reload for frontend (Quasar dev server)
- Debug mode enabled
- Verbose logging
- Source code volume mounts

### Frontend Development

The frontend runs with Quasar dev server that:
- Watches source files for changes
- Hot reloads on file changes
- Provides enhanced error messages
- Port: 80 (or `FRONTEND_PORT`)

```bash
# View frontend logs
docker-compose logs -f frontend

# Rebuild on source changes
docker-compose exec frontend npm run build
```

### Backend Development

Changes to PHP files are reflected immediately:
- No need to rebuild container
- Logs available via `docker-compose logs`

```bash
# View real-time logs
docker-compose logs -f backend

# Debug with Tinker
docker-compose exec backend php artisan tinker
```

### Database

SQLite database is stored at:
```
./backend/database.sqlite
```

For local development:
```bash
# Fresh migration
docker-compose exec backend php artisan migrate:fresh --seed

# Inspect database
docker-compose exec backend sqlite3 database.sqlite
```

## Production

### Production Setup

Use production compose file for optimized setup:

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**Features:**
- No volume mounts (immutable images)
- Health checks enabled
- Automatic restart on failure
- Production environment
- Minimal logging

### Build Production Images

```bash
# Build images
docker-compose -f docker-compose.prod.yml build

# Tag images
docker tag laravel-quasar_backend:latest myregistry.com/backend:1.0.0
docker tag laravel-quasar_frontend:latest myregistry.com/frontend:1.0.0

# Push to registry
docker push myregistry.com/backend:1.0.0
docker push myregistry.com/frontend:1.0.0
```

### Production Environment

Update backend `.env`:
```dotenv
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com
LOG_CHANNEL=stderr
```

### Using Pre-built Images

```yaml
# docker-compose.prod.yml
services:
  backend:
    image: myregistry.com/backend:1.0.0
  frontend:
    image: myregistry.com/frontend:1.0.0
```

### SSL/HTTPS

Add a reverse proxy (Nginx/Traefik):

```yaml
# docker-compose.prod.yml
reverse-proxy:
  image: traefik:latest
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./docker/traefik.yml:/traefik.yml
    - ./ssl/:/certs/
  command:
    - --config.file=/traefik.yml
```

### Scaling

Run multiple backend instances:

```bash
docker-compose up -d --scale backend=3
```

## Troubleshooting

### Connection Refused

**Problem**: `Connection refused` when accessing http://localhost

**Solution**:
```bash
# Check if containers are running
docker-compose ps

# Check logs
docker-compose logs backend
docker-compose logs frontend

# Restart
docker-compose restart
```

### Database Locked

**Problem**: `database is locked` error

**Solution**:
```bash
# SQLite is being accessed by multiple processes
# Reduce concurrent requests or use MySQL/PostgreSQL

# Quick fix - restart backend
docker-compose restart backend
```

### Port Already in Use

**Problem**: `Error: bind: address already in use`

**Solution**:
```bash
# Use different ports
BACKEND_PORT=8001 FRONTEND_PORT=3000 docker-compose up

# Or kill existing process
lsof -i :8000
kill -9 <PID>
```

### Out of Memory

**Problem**: Containers crash with OOM

**Solution**:
```yaml
# docker-compose.yml
services:
  backend:
    mem_limit: 512m
  frontend:
    mem_limit: 256m
```

### Slow Performance

**Problem**: Containers running slowly on Mac/Windows

**Solution**:
- Use named volumes instead of bind mounts
- Enable Docker resource limits
- Check Docker Dashboard resource usage

### Build Failures

**Problem**: Docker build fails

**Solution**:
```bash
# Clear build cache
docker-compose build --no-cache

# Check Dockerfile
docker build --progress=plain .

# Check logs
docker build --progress=plain -f Dockerfile .
```

### Frontend Not Updating

**Problem**: Changes not reflected in frontend

**Solution**:
```bash
# Check volume mounts
docker-compose exec frontend df

# Clear node modules and rebuild
docker-compose exec frontend rm -rf node_modules
docker-compose down -v
docker-compose up --build
```

## Advanced Topics

### Using MySQL/PostgreSQL

Replace SQLite in `.env`:

```dotenv
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=secret
```

Add to `docker-compose.yml`:

```yaml
db:
  image: mysql:8.0
  environment:
    MYSQL_DATABASE: laravel
    MYSQL_ROOT_PASSWORD: secret
  volumes:
    - db-data:/var/lib/mysql

volumes:
  db-data:
```

### Environment-specific Configs

```bash
# Development
docker-compose -f docker-compose.yml up

# Testing
docker-compose -f docker-compose.yml -f docker-compose.test.yml up

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

### CI/CD Integration

GitHub Actions workflow: `.github/workflows/docker-build.yml`

Builds, tests, and pushes images on:
- Push to main/develop
- Pull requests
- Tags

### Kubernetes Deployment

Convert to Kubernetes:
```bash
kompose convert -f docker-compose.yml -o k8s/
```

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Laravel Docker](https://laravel.com/docs/deployment#docker)
- [Quasar Docker](https://quasar.dev/start/umd)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## Support

For issues:
1. Check [DOCKER.md](DOCKER.md) for detailed guide
2. Review container logs: `docker-compose logs`
3. Check Docker status: `docker ps`
4. Verify image contents: `docker image inspect <image>`
