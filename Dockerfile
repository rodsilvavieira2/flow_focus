# Use an ARM64 Ubuntu base image
FROM ubuntu/22.04 AS builder

# Set environment variables to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

COPY . .

# Install dependencies for Flutter and Linux builds
# liblzma-dev is needed for the Flutter SDK itself
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    liblzma-dev \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libnotify-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Set up Flutter SDK
ENV FLUTTER_HOME=/opt/flutter
# You can specify a particular Flutter version if needed
ENV FLUTTER_VERSION=3.32.2
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# Download and install Flutter
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    flutter --version && \
    # Pre-download development binaries for Linux to save time later
    # and accept licenses
    flutter precache --linux && \
    flutter doctor && \
    yes | flutter doctor --android-licenses


RUN flutter config --enable-linux-desktop
RUN flutter build linux --release
RUN tar -czf /app/build.tar.gz -C build/linux/x64/release/bundle .
