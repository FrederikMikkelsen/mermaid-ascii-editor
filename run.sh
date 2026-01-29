#!/bin/bash

# Build and run the Vue development server in Docker on localhost port 9001

cd "$(dirname "$0")"

# Docker image and container names
IMAGE_NAME="mermaid-ascii-service"
CONTAINER_NAME="mermaid-ascii-service"

# Build the Docker image
echo "Building Docker image..."
if ! docker build -t "$IMAGE_NAME" .; then
    echo "Error: Docker build failed. Exiting."
    exit 1
fi

# # Print dependency versions
# echo ""
# echo "Dependency versions in image:"
# docker run --rm "$IMAGE_NAME" npm list --depth=0 2>/dev/null || docker run --rm "$IMAGE_NAME" npm ls --depth=0
# echo ""

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container..."
    docker stop "$CONTAINER_NAME" > /dev/null 2>&1
    docker rm "$CONTAINER_NAME" > /dev/null 2>&1
fi

# Run the container with port mapping in attached mode
echo "Starting container on port 9001..."
echo "Access the app at http://localhost:9001"
echo "Press Ctrl+C to stop the container"
docker run --rm \
    --name "$CONTAINER_NAME" \
    -p 9001:9001 \
    "$IMAGE_NAME"
