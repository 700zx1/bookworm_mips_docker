#!/bin/bash
set -e

# Use the exported variables from launch_podman_build_vice.sh
CORE_NAME=${CORE_NAME}
CORE_REPO=${CORE_REPO}

echo "Cloning $CORE_NAME core..."
git clone "$CORE_REPO"
cd "$CORE_NAME"

# Copy your platform-specific Makefile into the repo
cp /build/Makefile.sf3000 ./Makefile

if [ ! -f ./Makefile ]; then
  echo "❌ Makefile not found. Exiting."
  exit 1
fi

echo "Building $CORE_NAME with custom Makefile for SF3000..."
make platform=sf3000

mkdir -p /build/output
cp *.so /build/output/
