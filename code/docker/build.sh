set -e  # Exit immediately on error

# Configuration
CONTAINER_NAME="pulse_uni_db_container"
COMPOSE_FILE="docker-compose.yml"
TIMEOUT=120  # seconds

# Check Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "❌ ERROR: Docker daemon is not running. Please start Docker first."
  exit 1
fi

# Start the container
echo "🚀 Starting MySQL container..."
docker compose -f "$COMPOSE_FILE" up -d

# Wait for MySQL to be healthy
echo "⏳ Waiting for MySQL to initialize (timeout: $TIMEOUT sec)..."
start_time=$(date +%s)

while true; do
  sleep 5
  health_status=$(docker inspect --format '{{.State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "notfound")
  echo "🩺 Status: $health_status"

  # Timeout check
  now=$(date +%s)
  elapsed=$(( now - start_time ))
  if [ "$elapsed" -gt "$TIMEOUT" ]; then
    echo "❌ Timeout waiting for MySQL to become healthy"
    docker logs "$CONTAINER_NAME"
    exit 1
  fi

  if [ "$health_status" == "healthy" ]; then
    break
  fi
done

# Final check
if docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME\$"; then
  echo -e "\n✅ MySQL is running!"
  echo "🔗 Connection details:"
  echo "   Host: localhost"
  echo "   Port: 3306"
  echo "   User: myuser"
  echo "   Password: mypassword"
else
  echo "❌ Container is not running."
  docker logs "$CONTAINER_NAME"
  exit 1
fi
