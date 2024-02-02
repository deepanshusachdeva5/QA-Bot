# Stage 1: Build Stage
FROM python:3.8 AS build

# Set working directory for backend
WORKDIR /app/backend

# Copy and install backend dependencies
COPY backend/requirements.txt /app/backend/
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime Stage
FROM node:14-alpine

# Set working directory for the final image
WORKDIR /app

# Copy Python backend files from the build stage
COPY --from=build /app/backend /app/backend

# Copy frontend files
COPY frontend /app/frontend

# Set the working directory to frontend
WORKDIR /app/frontend

# Install frontend dependencies
RUN npm install

# Expose the port(s) your app will run on
EXPOSE 5000
EXPOSE 3000  # Expose the port used by React development server

# Set the working directory back to the root
WORKDIR /app

# Command to run both backend and frontend
CMD ["sh", "-c", "cd backend && python3 generate.py & cd ../frontend && npm start"]
