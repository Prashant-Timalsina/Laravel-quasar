.PHONY: help setup build up down logs restart clean migrate seed tinker bash-backend bash-frontend

help:
	@echo "Laravel-Quasar Docker Management"
	@echo ""
	@echo "Setup commands:"
	@echo "  make setup           - Full setup (build, start, migrate)"
	@echo "  make build           - Build Docker images"
	@echo ""
	@echo "Container commands:"
	@echo "  make up              - Start services"
	@echo "  make down            - Stop services"
	@echo "  make restart         - Restart services"
	@echo "  make logs            - View logs"
	@echo ""
	@echo "Database commands:"
	@echo "  make migrate         - Run database migrations"
	@echo "  make seed            - Seed database"
	@echo "  make fresh-seed      - Fresh migrations and seed"
	@echo ""
	@echo "Development commands:"
	@echo "  make tinker          - Open Laravel tinker"
	@echo "  make bash-backend    - Access backend shell"
	@echo "  make bash-frontend   - Access frontend shell"
	@echo ""
	@echo "Utility commands:"
	@echo "  make clean           - Stop and remove containers"
	@echo "  make clean-all       - Remove everything (WARNING: deletes data)"
	@echo "  make status          - Show service status"
	@echo ""

setup: build up migrate
	@echo "Setup complete!"

build:
	docker-compose build

up:
	docker-compose up -d
	@echo "Services started at:"
	@echo "  Frontend: http://localhost"
	@echo "  Backend:  http://localhost:8000"

down:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

migrate:
	docker-compose exec -T backend php artisan migrate

migrate-fresh:
	docker-compose exec -T backend php artisan migrate:fresh

migrate-rollback:
	docker-compose exec -T backend php artisan migrate:rollback

seed:
	docker-compose exec -T backend php artisan db:seed

fresh-seed: migrate-fresh seed

tinker:
	docker-compose exec backend php artisan tinker

bash-backend:
	docker-compose exec backend sh

bash-frontend:
	docker-compose exec frontend sh

composer-install:
	docker-compose exec backend composer install

composer-update:
	docker-compose exec backend composer update

npm-install:
	docker-compose exec frontend npm install

npm-update:
	docker-compose exec frontend npm update

clean:
	docker-compose down

clean-all:
	docker-compose down -v
	@echo "WARNING: All data has been removed!"

status:
	docker-compose ps

dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
	@echo "Development services started with hot reload enabled"

prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo "Production services started"

test:
	docker-compose exec -T backend php artisan test

shell-backend:
	docker-compose exec backend sh

shell-frontend:
	docker-compose exec frontend sh
