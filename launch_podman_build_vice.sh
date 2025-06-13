#!/bin/bash
set -e

# Define variables
CORE_NAME="vice-libretro"
CORE_REPO="https://github.com/libretro/vice-libretro.git"
OUTPUT_DIR="$PWD/output"
IMAGE_NAME="libretro-mips-builder"
HASH_FILE=".last_build_hash"

# Export variables so they are accessible in build_core.sh
export CORE_NAME
export CORE_REPO

mkdir -p "$OUTPUT_DIR"

# Calculate current build context hash (Dockerfile + build_core.sh + Makefile.mips32r2)
BUILD_HASH=$(find . -maxdepth 1 -name 'Dockerfile' -o -name 'build_core.sh' -o -name 'Makefile.mips32r2' -exec sha256sum {} \; | sha256sum | awk '{print $1}')

# Compare to previous
if [ ! -f "$HASH_FILE" ] || [ "$BUILD_HASH" != "$(cat $HASH_FILE)" ]; then
    echo "[+] Changes detected or no cache found. Rebuilding Podman image: $IMAGE_NAME"
    podman build -t $IMAGE_NAME .
    echo "$BUILD_HASH" > "$HASH_FILE"
else
    echo "[✓] No changes in build context. Using cached image: $IMAGE_NAME"
fi

# Run the build
echo "[+] Running build for core: $CORE_NAME"
podman run --rm \
    -e CORE_NAME \
    -e CORE_REPO \
    -v "$OUTPUT_DIR":/build/output:Z \
    -v "$PWD/Makefile.sf3000":/build/Makefile.sf3000:Z \
    $IMAGE_NAME /build/build_core.sh "$CORE_NAME" "$CORE_REPO"

echo "[✓] Build complete. Output is in: $OUTPUT_DIR"
