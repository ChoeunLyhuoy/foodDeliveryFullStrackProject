#!/bin/bash
set -e

echo "🐳 Building Docker images if not already built..."
docker compose build

echo "💾 Saving Docker images (foodgo-backend, foodgo-frontend, foodgo-mobile, mysql:8.0) to archive..."
docker save foodgo-backend:latest foodgo-frontend:latest foodgo-mobile:latest mysql:8.0 -o foodgo-docker-images.tar

echo "📜 Creating offline loader script..."
cat << 'EOF' > load_and_run.sh
#!/bin/bash
set -e
echo "📥 Loading Docker images..."
docker load -i foodgo-docker-images.tar
echo "🚀 Starting containers..."
docker compose up -d
echo "✅ FoodGo platform is running! Vue Frontend: http://localhost:5173 | Flutter App: http://localhost:8081 | Backend API: http://localhost:8080/api"
EOF
chmod +x load_and_run.sh

echo "📦 Compressing into foodgo-docker-offline-bundle.zip..."
zip -r foodgo-docker-offline-bundle.zip \
  foodgo-docker-images.tar \
  docker-compose.yml \
  database/ \
  load_and_run.sh

rm foodgo-docker-images.tar load_and_run.sh
echo "🎉 Created foodgo-docker-offline-bundle.zip! You can copy this ZIP anywhere and run offline."
