#!/bin/bash
set -e

echo "📦 Creating clean project ZIP archive (excluding target, node_modules, build folders)..."
zip -r foodgo-project-complete.zip . \
  -x "*.git*" \
  -x "*/target/*" \
  -x "*/node_modules/*" \
  -x "*/dist/*" \
  -x "*/.dart_tool/*" \
  -x "*/build/*" \
  -x "*/.idea/*" \
  -x "*.DS_Store*" \
  -x "foodgo-project-complete.zip" \
  -x "foodgo-docker-offline-bundle.zip"

echo "✅ Created foodgo-project-complete.zip successfully!"
