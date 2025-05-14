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
# Terminate container if it exists
docker compose down -v

# Start containers
echo "Starting MySQL container..."
docker compose -f $composeFile up -d

# Wait for container to become healthy
echo "Waiting for MySQL container to become healthy..."
$timeout = 120
$startTime = Get-Date

do {
    Start-Sleep -Seconds 3
    $healthStatus = docker inspect --format "{{.State.Health.Status}}" $containerName 2>$null
    echo "Current health status: $healthStatus"

    if (((Get-Date) - $startTime).TotalSeconds -gt $timeout) {
        echo "`n❌ Timeout waiting for MySQL to report healthy."
        docker logs $containerName
        exit 1
    }
} until ($healthStatus -eq "healthy")

# Wait until init scripts are done by watching the logs
echo "`nWaiting for MySQL init scripts to complete..."
$logCheckTimeout = 150
$logStartTime = Get-Date
$done = $false
$progress = 0

while (-not $done -and ((Get-Date) - $logStartTime).TotalSeconds -lt $logCheckTimeout) {
    $recentLogs = docker logs $containerName --since 2s
    $logText = $recentLogs -join "`n"

    if ($logText -like "*init process done. Ready for start up.*") {
        $done = $true
        Write-Host "`n✅ Init scripts completed!"
        break
    }

    $progress = [math]::Round(((Get-Date) - $logStartTime).TotalSeconds / $logCheckTimeout * 100)
    Write-Progress -Activity "Waiting for init scripts to finish..." -Status "$progress% complete" -PercentComplete $progress
}

if (-not $done) {
    echo "`n❌ Timeout waiting for init scripts to finish."
    docker logs $containerName
    exit 1
}
# Final verification
echo "`nFinal verification..."
$runningContainers = docker ps --filter "name=$containerName" --format "{{.Names}}"

if ($runningContainers -match $containerName) {
    echo "`n✅ MySQL is running and initialized!"
    echo "Connection details:"
    echo "   Host: localhost"
    echo "   Port: 3306"
    echo "   User: myuser"
    echo "   Password: mypassword"
} else {
    echo "`n❌ Container failed to start"
    docker logs $containerName
    exit 1
}
