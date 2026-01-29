FROM node:lts-alpine3.23

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port 9001
EXPOSE 9001

# Run the development server
CMD ["npm", "run", "dev", "--", "--port", "9001", "--host", "0.0.0.0"]
