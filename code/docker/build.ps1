# Stop execution on error
$ErrorActionPreference = "Stop"

# Set MySQL container name
$containerName = "pulse_uni_db_container"

echo "Starting MySQL container..."
docker-compose up -d

# Wait for MySQL to initialize
echo "Waiting for MySQL to initialize..."
Start-Sleep -Seconds 10

# Load SQL scripts
echo "Loading database schema and data..."
docker exec -i $containerName mysql -u root -prootpassword ../../sql/install.sql
#docker exec -i $containerName mysql -u root -prootpassword ../../sql/load_data.sql
docker exec -i $containerName mysql -u root -prootpassword ../../sql/triggers.sql

echo "MySQL setup complete!"

# Check if the container is running
$runningContainers = docker ps --format "{{.Names}}"
if ($runningContainers -match $containerName) {
    echo "MySQL is running on localhost:3306"
} else {
    echo "MySQL container is not running. Check logs with: docker logs $containerName"
}

echo "Connect using MySQL Workbench with:"
echo "   - Host: localhost"
echo "   - Port: 3306"
echo "   - User: myuser"
echo "   - Password: mypassword"
