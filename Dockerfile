# Dockerfile for Smart Card Backend
FROM node:18-alpine

WORKDIR /app/backend

# Copy only package files first (for better Docker layer caching)
COPY backend/package.json backend/package-lock.json* ./

# Install dependencies
RUN npm ci --only=production --omit=dev || npm install --production --omit=dev

# Copy only backend files (exclude Flutter, docs, etc.)
COPY backend/ ./

# Expose port (Railway will assign PORT dynamically)
EXPOSE 3000

# Health check for Railway
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:${PORT:-3000}/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start server
CMD ["node", "server.js"]

