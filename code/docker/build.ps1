# Stop execution on error
$ErrorActionPreference = "Stop"

# Set MySQL container name
$containerName = "pulse_university_db_container"

Write-Host "🚀 Starting MySQL container..."
docker-compose up -d

# Wait for MySQL to initialize
Write-Host "⏳ Waiting for MySQL to initialize..."
Start-Sleep -Seconds 10

# Load SQL scripts
Write-Host "📂 Loading database schema and data..."
docker exec -i $containerName mysql -u root -prootpassword < ../../sql/install.sql
#docker exec -i $containerName mysql -u root -prootpassword < ../../sql/load_data.sql
docker exec -i $containerName mysql -u root -prootpassword < ../../sql/triggers.sql

Write-Host "✅ MySQL setup complete!"

# Check if the container is running
$runningContainers = docker ps --format "{{.Names}}"
if ($runningContainers -match $containerName) {
    Write-Host "🎉 MySQL is running on localhost:3306"
} else {
    Write-Host "❌ MySQL container is not running. Check logs with: docker logs $containerName"
}

Write-Host "🔗 Connect using MySQL Workbench with:"
Write-Host "   - Host: localhost"
Write-Host "   - Port: 3306"
Write-Host "   - User: myuser"
Write-Host "   - Password: mypassword"
