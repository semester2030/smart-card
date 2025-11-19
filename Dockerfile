# Dockerfile for Smart Card Backend
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY backend/package*.json ./backend/

# Install dependencies
WORKDIR /app/backend
RUN npm ci --only=production

# Copy backend files
COPY backend/ ./

# Expose port
EXPOSE 3000

# Start server
CMD ["node", "server.js"]

