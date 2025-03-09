# Start containers
echo "Starting MySQL container..."
docker compose -f $composeFile up -d

# Wait for MySQL to become healthy
echo "Waiting for MySQL to initialize..."
do {
    Start-Sleep -Seconds 5
    $healthStatus = docker inspect --format "{{.State.Health.Status}}" $containerName 2>$null
    echo "Current status: $healthStatus"
} until ($healthStatus -eq "healthy")

# Verify container status
echo "`nFinal verification..."
$runningContainers = docker ps --filter "name=$containerName" --format "{{.Names}}"

if ($runningContainers -match $containerName) {
    echo "`n✅ MySQL is running successfully!"
    echo "`nConnection details:"
    echo "   Host: localhost"
    echo "   Port: 3306"
    echo "   User: myuser"
    echo "   Password: mypassword"
    echo "`nYou can now connect using MySQL Workbench or CLI."
}
else {
    echo "`n❌ Container failed to start. Check logs with: docker logs $containerName"
    exit 1
}
