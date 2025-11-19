# Dockerfile for Smart Card Backend
FROM node:18-alpine

WORKDIR /app/backend

# Copy package files first (for better caching)
COPY backend/package.json ./
COPY backend/package-lock.json* ./

# Install dependencies (use npm ci for production)
RUN npm ci --only=production

# Copy all backend files
COPY backend/ ./

# Expose port (Railway will assign PORT dynamically)
EXPOSE 3000

# Start server
CMD ["node", "server.js"]

