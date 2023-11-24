#!/bin/bash

# Start Docker Compose in the background
docker compose up -d

# Check the exit status of services
docker compose ps -q | xargs -I {} docker inspect -f '{{.State.ExitCode}}' {} | grep -q 0

# Capture the exit code
exit_code=$?

docker compose ps -q | xargs -I {} docker inspect -f '{{.State}}' {}

message=$?
echo "$message"
# Check if any service exited with a non-zero status
if [ $exit_code -ne 0 ]; then
    echo "At least one service failed"
    docker compose down          # Stop the services only if a service failed
    echo "Exit code: $exit_code" # Print the exit code
    echo "$message"
    exit 1
fi

# All services are running successfully
exit 0
