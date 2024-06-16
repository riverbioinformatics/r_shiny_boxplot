#!/bin/bash

IMAGE_NAME="shiny_ggplot2_readr"
VERSION="1.0.0-rc"
SINGULARITY_CACHE_DIR="${NXF_SINGULARITY_CACHEDIR}/${IMAGE_NAME}"
IMAGE_PATH="${SINGULARITY_CACHE_DIR}/${IMAGE_NAME}-${VERSION}.sif"
DEFINITION_PATH="${SINGULARITY_CACHE_DIR}/${IMAGE_NAME}-${VERSION}.def"

# Check if NXF_SINGULARITY_CACHEDIR is set
if [ -z "${NXF_SINGULARITY_CACHEDIR}" ]; then
    echo "Error: NXF_SINGULARITY_CACHEDIR is not set."
    exit 1
fi

# Create cache directory if it doesn't exist
mkdir -p "${SINGULARITY_CACHE_DIR}"

# Check if the Singularity image already exists
if [ -f "${IMAGE_PATH}" ]; then
    echo "Using existing image: ${IMAGE_PATH}"
else
    echo "Image not found. Building image..."
    cp "${TOOLS}/river_r_shiny/singularity.def" "${DEFINITION_PATH}"
    singularity build --fakeroot "${IMAGE_PATH}" "${DEFINITION_PATH}"
fi

# Run the Shiny application
singularity exec -B "${TOOLS}/river_r_shiny/app.R:/srv/shiny-server/app.R" "${IMAGE_PATH}" R -e "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=${PORT})"