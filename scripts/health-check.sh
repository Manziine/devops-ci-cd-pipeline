#!/usr/bin/env bash
# health-check.sh — Verify deployment succeeded
# Usage: ./scripts/health-check.sh [HOST] [PORT]

HOST="${1:-localhost}"
PORT="${2:-8000}"
MAX_RETRIES=10
RETRY_INTERVAL=5

echo "Health check: http://$HOST:$PORT/health"

for i in $(seq 1 $MAX_RETRIES); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://$HOST:$PORT/health" 2>/dev/null || echo "000")
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ Health check PASSED (HTTP $HTTP_CODE) after $i attempt(s)"
        exit 0
    fi
    
    echo "⏳ Attempt $i/$MAX_RETRIES: HTTP $HTTP_CODE — retrying in ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
done

echo "❌ Health check FAILED after $MAX_RETRIES attempts"
exit 1