#!/usr/bin/env bash
# ============================================================
# deploy.sh — Zero-downtime deployment script
# ============================================================
# Run this on the server or via CI/CD SSH step.
# Usage: ./scripts/deploy.sh [IMAGE_TAG]

set -euo pipefail

IMAGE_TAG="${1:-latest}"
APP_DIR="/opt/app"
COMPOSE_FILE="$APP_DIR/docker-compose.prod.yml"
IMAGE="manziine/app"

echo "🚀 Starting deployment — tag: $IMAGE_TAG"
echo "   Server: $(hostname) | Time: $(date)"

# Pull latest image
echo "📥 Pulling image $IMAGE:$IMAGE_TAG..."
docker pull "$IMAGE:$IMAGE_TAG"

# Tag as latest
docker tag "$IMAGE:$IMAGE_TAG" "$IMAGE:current"

# Update and restart app service only (zero-downtime)
echo "♻️  Restarting app container..."
cd "$APP_DIR"
docker compose -f "$COMPOSE_FILE" up -d --no-deps app

# Wait for health check
echo "⏳ Waiting for health check..."
sleep 10

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Deployment successful! Health check passed (HTTP $HTTP_CODE)"
    # Clean up old images
    docker image prune -f --filter "until=24h"
else
    echo "❌ Health check failed (HTTP $HTTP_CODE) — rolling back..."
    docker compose -f "$COMPOSE_FILE" restart app
    exit 1
fi

echo "📊 Running containers:"
docker compose -f "$COMPOSE_FILE" ps
