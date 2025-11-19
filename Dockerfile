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

# Set environment to production
ENV NODE_ENV=production

# Start server with explicit output
# Note: Railway handles health checks automatically via /health endpoint
# Using simple server first to test if Railway can start it
# Use exec form to ensure proper signal handling
CMD ["node", "server-simple.js"]

