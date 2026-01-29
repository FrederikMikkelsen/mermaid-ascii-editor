#!/bin/bash

# Build the Vue application in Docker and save the output to a dist folder

cd "$(dirname "$0")"

# Docker image and container names
IMAGE_NAME="mermaid-ascii-service"
CONTAINER_NAME="mermaid-ascii-service-build"

# Build the Docker image
echo "Building Docker image..."
if ! docker build -t "$IMAGE_NAME" .; then
    echo "Error: Docker build failed. Exiting."
    exit 1
fi

# Remove existing dist folder if it exists
if [ -d "dist" ]; then
    echo "Removing existing dist folder..."
    rm -rf dist
fi

# Create a temporary container and run the build
echo "Building the application..."
BUILD_CONTAINER=$(docker create "$IMAGE_NAME" npm run build)

if [ -z "$BUILD_CONTAINER" ]; then
    echo "Error: Failed to create container. Exiting."
    exit 1
fi

# Start the container to run the build
if ! docker start -a "$BUILD_CONTAINER"; then
    echo "Error: Build failed. Cleaning up..."
    docker rm "$BUILD_CONTAINER" > /dev/null 2>&1
    exit 1
fi

# Copy the dist folder from the container to the local filesystem
echo "Copying dist folder from container..."
if ! docker cp "$BUILD_CONTAINER:/app/dist" ./dist; then
    echo "Error: Failed to copy dist folder. Cleaning up..."
    docker rm "$BUILD_CONTAINER" > /dev/null 2>&1
    exit 1
fi

# Clean up the container
docker rm "$BUILD_CONTAINER" > /dev/null 2>&1

echo "Build complete! Output saved to ./dist"
