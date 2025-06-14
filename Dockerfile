# Use an Ubuntu base image (multi-arch)
FROM ubuntu:22.04 AS builder

# Set environment variables to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

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
    libayatana-appindicator3-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Flutter SDK
ENV FLUTTER_HOME=/opt/flutter
# Accept Flutter version as build argument
ARG FLUTTER_VERSION=3.32.1
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# Download and install Flutter
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    flutter --version && \
    # Pre-download development binaries for Linux to save time later
    # and accept licenses
    flutter precache --linux && \
    flutter doctor && \
    yes | flutter doctor --android-licenses || true

# Copy source code
COPY . .

# Configure Flutter and build
RUN flutter config --enable-linux-desktop
RUN flutter pub get
RUN flutter build linux --release

# Create tar.gz with proper architecture detection
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then \
    BUILD_PATH="build/linux/arm64/release/bundle"; \
    else \
    BUILD_PATH="build/linux/x64/release/bundle"; \
    fi && \
    tar -czf /app/build.tar.gz -C $BUILD_PATH .

# Final stage to output the build artifact
FROM scratch AS export-stage
COPY --from=builder /app/build.tar.gz /build.tar.gz
