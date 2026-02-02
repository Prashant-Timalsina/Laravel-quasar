# Docker Quick Reference

## Getting Started

```bash
# First time setup
cp .env.docker backend/.env
docker-compose up --build -d
docker-compose exec backend php artisan migrate

# Access
Frontend: http://localhost
Backend:  http://localhost:8000
API:      http://localhost:8000/api
```

## Essential Commands

```bash
# Start/Stop
docker-compose up -d              # Start in background
docker-compose stop               # Stop all services
docker-compose restart            # Restart services
docker-compose down               # Stop and remove containers
docker-compose down -v            # Stop and remove everything

# Logs
docker-compose logs -f            # View all logs
docker-compose logs -f backend    # View backend logs
docker-compose logs -f frontend   # View frontend logs

# Execute
docker-compose exec backend php artisan <command>
docker-compose exec backend composer <command>
docker-compose exec frontend npm <command>
docker-compose exec backend sh    # Shell access
```

## Database

```bash
# Migrations
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan migrate:refresh
docker-compose exec backend php artisan migrate:rollback

# Seeding
docker-compose exec backend php artisan db:seed
docker-compose exec backend php artisan migrate:fresh --seed

# Access database
docker-compose exec backend sqlite3 database.sqlite
```

## Development

```bash
# Use dev compose file (hot reload)
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Frontend hot reload
# - Changes in src/ are instantly reflected
# - Check http://localhost for updates

# Backend instant changes
# - PHP files are mounted, no rebuild needed
# - View logs: docker-compose logs -f backend
```

## Production

```bash
# Use production compose file
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Build for deployment
docker-compose -f docker-compose.prod.yml build
docker tag laravel-quasar_backend:latest myrepo/backend:v1.0
docker push myrepo/backend:v1.0
```

## Troubleshooting

```bash
# Check status
docker-compose ps

# View image details
docker images
docker image inspect <image>

# Clean up
docker system prune           # Remove unused images/containers
docker volume prune          # Remove unused volumes
docker-compose down -v       # Remove everything for this project

# Rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Reset database
docker-compose exec backend php artisan migrate:fresh --seed
```

## Ports

| Service | Default | Custom |
|---------|---------|--------|
| Frontend | 80 | FRONTEND_PORT |
| Backend | 8000 | BACKEND_PORT |

```bash
# Change ports
BACKEND_PORT=8001 FRONTEND_PORT=3000 docker-compose up
```

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Backend/Frontend image definition |
| `docker-compose.yml` | Main orchestration |
| `docker-compose.dev.yml` | Development overrides |
| `docker-compose.prod.yml` | Production overrides |
| `backend/docker/*` | Backend configs |
| `frontend/docker/*` | Frontend configs |
| `DOCKER.md` | Detailed guide |
| `DOCKER-USAGE.md` | Usage examples |

## Environment Variables

**Backend (.env)**
```
APP_ENV=local
APP_DEBUG=true
DB_CONNECTION=sqlite
```

**Docker Compose**
```
BACKEND_PORT=8000
FRONTEND_PORT=80
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Port in use | Use different: `BACKEND_PORT=8001 docker-compose up` |
| Container won't start | `docker-compose logs -f backend` |
| Changes not showing | `docker-compose down -v && docker-compose up --build` |
| Database locked | `docker-compose restart backend` |
| Out of memory | Check Docker resources in Dashboard |

## Development Workflow

```bash
# 1. Start with dev compose
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# 2. Edit code (auto-reload enabled)
# 3. View changes at http://localhost

# 4. Run commands as needed
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan tinker

# 5. Stop when done
docker-compose down
```

## Useful One-liners

```bash
# Get shell with all bash tools
docker-compose exec backend apk add bash && docker-compose exec backend bash

# Check if services are healthy
docker-compose ps

# Get backend container IP
docker-compose exec backend hostname -i

# Test API
curl http://localhost:8000/api

# Tail logs with timestamps
docker-compose logs -f --timestamps

# Watch container resource usage
docker stats
```

For detailed information, see [DOCKER.md](DOCKER.md) and [DOCKER-USAGE.md](DOCKER-USAGE.md)
