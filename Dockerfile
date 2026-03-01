FROM node:22-bookworm-slim

# Install Chrome dependencies for headless rendering
RUN apt-get update && apt-get install -y \
    libnss3 \
    libdbus-1-3 \
    libatk1.0-0 \
    libgbm-dev \
    libasound2 \
    libxrandr2 \
    libxkbcommon-dev \
    libxfixes3 \
    libxcomposite1 \
    libxdamage1 \
    libatk-bridge2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libcups2 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Use the official Hello World starter template as the default project
RUN git clone --depth=1 https://github.com/remotion-dev/template-helloworld.git /app \
    && rm -rf /app/.git

# Install dependencies
RUN npm install

# Install Chrome Headless Shell for rendering
RUN npx remotion browser ensure

# Create output directory for rendered videos
RUN mkdir -p /app/out

EXPOSE 3000

CMD ["npx", "remotion", "studio", "--ipv4", "--port", "3000"]
