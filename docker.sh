#!/bin/bash

# Docker setup and management script for Laravel-Quasar

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_header() {
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  $1${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        exit 1
    fi
    print_success "Docker is installed"
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed"
        exit 1
    fi
    print_success "Docker Compose is installed"
}

# Setup environment
setup_env() {
    print_header "Setting Up Environment"
    
    if [ ! -f "backend/.env" ]; then
        cp .env.docker backend/.env
        print_success "Created backend/.env"
    else
        print_info "backend/.env already exists"
    fi
    
    if ! grep -q "APP_KEY=" backend/.env || grep -q "APP_KEY=$" backend/.env; then
        print_info "Generating Laravel APP_KEY..."
        docker-compose run --rm backend php artisan key:generate --show > /tmp/key.txt
        KEY=$(cat /tmp/key.txt | grep -oP 'APP_KEY=\K[^:]*')
        sed -i "s/^APP_KEY=.*/APP_KEY=$KEY/" backend/.env
        rm /tmp/key.txt
        print_success "Laravel APP_KEY generated"
    fi
}

# Build images
build_images() {
    print_header "Building Docker Images"
    
    docker-compose build --no-cache
    print_success "Docker images built successfully"
}

# Start services
start_services() {
    print_header "Starting Services"
    
    docker-compose up -d
    print_success "Services started"
    
    # Wait for services to be ready
    print_info "Waiting for services to be ready..."
    sleep 5
}

# Initialize database
init_database() {
    print_header "Initializing Database"
    
    docker-compose exec -T backend php artisan migrate --force
    print_success "Database migrations completed"
    
    read -p "Do you want to seed the database? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose exec -T backend php artisan db:seed
        print_success "Database seeded"
    fi
}

# Show status
show_status() {
    print_header "Services Status"
    
    docker-compose ps
    
    print_header "Access Information"
    echo "Frontend:  http://localhost"
    echo "Backend:   http://localhost:8000"
    echo "API:       http://localhost:8000/api"
}

# Full setup
full_setup() {
    print_header "Full Docker Setup for Laravel-Quasar"
    
    check_prerequisites
    setup_env
    build_images
    start_services
    init_database
    show_status
    
    print_success "Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "  - Open http://localhost in your browser"
    echo "  - Run 'docker-compose logs -f' to view logs"
    echo "  - Run './docker.sh help' for more commands"
}

# Help
show_help() {
    cat << EOF
Laravel-Quasar Docker Management Script

Usage: ./docker.sh [COMMAND]

Commands:
  setup         Full setup (prerequisites, env, build, start, migrate)
  build         Build Docker images
  start         Start services
  stop          Stop services
  restart       Restart services
  logs          View service logs
  migrate       Run database migrations
  seed          Seed the database
  tinker        Open Laravel tinker console
  bash-backend  Open bash shell in backend container
  bash-frontend Open bash shell in frontend container
  clean         Stop and remove containers
  clean-all     Stop, remove containers and volumes (WARNING: deletes data)
  status        Show services status
  help          Show this help message

Examples:
  ./docker.sh setup           # Full setup
  ./docker.sh logs            # View logs
  ./docker.sh migrate         # Run migrations
  ./docker.sh bash-backend    # Access backend container

EOF
}

# Main script logic
case "${1:-help}" in
    setup)
        full_setup
        ;;
    build)
        check_prerequisites
        build_images
        ;;
    start)
        start_services
        show_status
        ;;
    stop)
        print_header "Stopping Services"
        docker-compose stop
        print_success "Services stopped"
        ;;
    restart)
        print_header "Restarting Services"
        docker-compose restart
        print_success "Services restarted"
        ;;
    logs)
        docker-compose logs -f
        ;;
    migrate)
        print_header "Running Database Migrations"
        docker-compose exec backend php artisan migrate
        print_success "Migrations completed"
        ;;
    seed)
        print_header "Seeding Database"
        docker-compose exec backend php artisan db:seed
        print_success "Database seeded"
        ;;
    tinker)
        docker-compose exec backend php artisan tinker
        ;;
    bash-backend)
        docker-compose exec backend sh
        ;;
    bash-frontend)
        docker-compose exec frontend sh
        ;;
    clean)
        print_header "Cleaning Up"
        docker-compose down
        print_success "Containers stopped and removed"
        ;;
    clean-all)
        print_header "Full Cleanup (WARNING: This will delete data)"
        read -p "Are you sure? This will delete database and volumes. (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose down -v
            print_success "Containers, volumes removed"
        else
            print_info "Cleanup cancelled"
        fi
        ;;
    status)
        show_status
        ;;
    help)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
