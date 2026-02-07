FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for Playwright browsers
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    curl \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js from NodeSource (version 20 LTS)
# This ensures Node.js is available for robotframework-browser
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Verify node and npm are available
RUN node --version && npm --version

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Initialize Playwright browsers (node should now be in PATH)
RUN rfbrowser init --skip-browsers
RUN rfbrowser install chromium

# Copy project files
COPY . .

# Create necessary directories
RUN mkdir -p reports resources

# Initialize database (if init_db.py exists)
RUN if [ -f init_db.py ]; then python init_db.py; fi

# Default command to run tests
CMD ["robot", "--outputdir", "reports", "tests"]
