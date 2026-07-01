#!/bin/bash

# Check if Java 17+ is installed locally
CURRENT_JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)

if [ "$CURRENT_JAVA_VER" = "1" ] || [ "$CURRENT_JAVA_VER" -lt 17 ] 2>/dev/null; then
    echo "⚠️  Local Java version is Java 8 ($CURRENT_JAVA_VER). Spring Boot 3 requires Java 17."
    echo "🐳 Running Spring Boot automatically via Java 17 Docker container..."
    echo "------------------------------------------------------------------------"
    docker run --rm -it \
      --name foodgo-backend-dev \
      --network host \
      -v "$(pwd)":/app \
      -v ~/.m2:/root/.m2 \
      -w /app \
      -e DB_HOST=localhost \
      -e DB_PORT=3307 \
      maven:3.9.6-eclipse-temurin-17 \
      mvn spring-boot:run
else
    echo "✅ Java 17+ detected. Running locally..."
    mvn spring-boot:run
fi
