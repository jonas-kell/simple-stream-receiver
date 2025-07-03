FROM debian:bookworm

# Install dependencies
RUN apt update && apt install -y \
    ffmpeg \
    libgl1 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libpulse0 \
    libasound2 \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

# Default command: play the stream
ENTRYPOINT ["ffplay"]