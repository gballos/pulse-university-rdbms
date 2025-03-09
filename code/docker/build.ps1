# Stop execution on error
$ErrorActionPreference = "Stop"

# Configuration
$containerName = "pulse_uni_db_container"
$composeFile = "docker-compose.yml"

# Verify Docker is running
try {
    docker info | Out-Null
}
catch {
    echo "ERROR: Docker daemon is not running. Start Docker Desktop first!"
    exit 1
}

# Start containers
echo "Starting MySQL container..."
docker-compose -f $composeFile up -d

# Wait for MySQL to initialize
echo "Waiting for MySQL to initialize..."
$timeout = 120  # 2-minute timeout
$startTime = Get-Date

do {
    Start-Sleep -Seconds 5
    $healthStatus = docker inspect --format "{{.State.Health.Status}}" $containerName 2>$null
    echo "Current status: $healthStatus"
    
    # Timeout check (FIXED SYNTAX)
    if ( ((Get-Date) - $startTime).TotalSeconds -gt $timeout ) {
        echo "`n❌ Timeout waiting for MySQL to start"
        docker logs $containerName
        exit 1
    }
} until ($healthStatus -eq "healthy")

# Verify container status
echo "`nFinal verification..."
$runningContainers = docker ps --filter "name=$containerName" --format "{{.Names}}"

if ($runningContainers -match $containerName) {
    echo "`n✅ MySQL is running successfully!"
    echo "Connection details:"
    echo "   Host: localhost"
    echo "   Port: 3306"
    echo "   User: myuser"
    echo "   Password: mypassword"
}
else {
    echo "`n❌ Container failed to start"
    docker logs $containerName
    exit 1
}
