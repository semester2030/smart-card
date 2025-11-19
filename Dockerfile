# Dockerfile for Smart Card Backend
FROM node:18-alpine

WORKDIR /app/backend

# Copy package files first (for better caching)
COPY backend/package.json ./

# Install dependencies
# Use npm install instead of npm ci if package-lock.json doesn't exist
RUN npm install --production --omit=dev

# Copy all backend files
COPY backend/ ./

# Expose port (Railway will assign PORT dynamically)
EXPOSE 3000

# Start server
CMD ["node", "server.js"]

