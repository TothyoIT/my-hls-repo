FROM ubuntu:22.04

# Install FFmpeg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work
# Copy script and player HTML
COPY repack.sh /work/repack.sh
COPY index.html /work/index.html
RUN chmod +x /work/repack.sh

# Run script via bash to avoid exec format errors
ENTRYPOINT ["bash", "/work/repack.sh"]
