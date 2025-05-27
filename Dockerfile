# Dockerfile
FROM ubuntu:22.04

# Install FFmpeg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work

# Copy the repack script and player HTML into the image
COPY repack.sh /work/repack.sh
COPY index.html /work/index.html
RUN chmod +x /work/repack.sh

# Run the repack script on container start
ENTRYPOINT ["bash", "/work/repack.sh"]
