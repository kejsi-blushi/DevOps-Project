# Build the application
FROM node:19-alpine3.16 as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json to the working directory
COPY package*.json ./

# Copy the rest of the application code to the working directory
COPY . .

# Install react-scripts globally and Build the application
RUN npm install -g react-scripts
RUN npm install
RUN npm run build

#  Serve the application
FROM nginx:1.23.4

# Copy the built application from the previous stage to the nginx default serving directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for serving the application
EXPOSE 80

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]
