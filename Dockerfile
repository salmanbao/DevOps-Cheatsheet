# syntax=docker/dockerfile:1.4
# Use Dockerfile syntax v1.4 (for BuildKit features like RUN --mount)

############################################################
# Stage 1: Builder - Install dependencies and build the app
############################################################

# Define build-time argument for Node.js version (can be overridden at build time)
ARG NODE_VERSION=18

# Use an official Node.js image (full version) as the build stage
FROM node:${NODE_VERSION} AS builder

# Set working directory for the build context
WORKDIR /app

# Copy package definition files first (leveraging Docker cache if unchanged)
# This includes package.json and package-lock.json (or yarn.lock) for npm install
COPY package*.json ./ 

# (Optional) Copy other config files (e.g., .npmrc) if needed for install
# In this example, we will use BuildKit secrets for private registries instead of copying .npmrc

# Install dependencies (including devDependencies) using npm ci for a clean, reproducible build.
# Use BuildKit cache mount to speed up repeated builds by caching ~/.npm, and secret mount for .npmrc (private repo credentials).
RUN --mount=type=secret,id=npmrc,dst=/root/.npmrc \ 
    --mount=type=cache,target=/root/.npm \ 
    npm ci 

# Copy the rest of the application's source code to the container
COPY . . 

# (Optional) Use a custom shell for RUN instructions in this stage (e.g., bash with pipefail)
# This ensures that a pipeline failure causes the RUN to fail.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build the application (e.g., compile TypeScript or bundle front-end assets)
# If your project doesn't have a build step, you can omit this.
RUN npm run build

# Remove development dependencies to keep only production deps (reduces final image size)
RUN npm prune --production

# At this point, the builder stage has:
# - Built application assets (e.g., in /app/dist)
# - A node_modules folder with only production dependencies

############################################################
# Stage 2: Runtime - Create a lean production image
############################################################

# Use a smaller Node.js runtime base image for the final image
FROM node:${NODE_VERSION}-slim AS runtime

# Set working directory in the final image
WORKDIR /app

# Label metadata for the image (name, version, description, maintainer, etc.)
LABEL maintainer="Your Name <you@example.com>" \ 
      org.opencontainers.image.title="My Node.js App" \ 
      org.opencontainers.image.description="Production Docker image for a Node.js application" \ 
      org.opencontainers.image.version="1.0.0"

# Set environment variables for the application
# NODE_ENV=production ensures that Node.js and libraries run in production mode
# PORT is an example application port (optional, could also be set at runtime)
ENV NODE_ENV=production \ 
    PORT=3000

# (Optional) Use BuildKit to cache apt packages and install additional utilities (here we install curl for healthcheck)
RUN --mount=type=cache,target=/var/cache/apt \ 
    --mount=type=cache,target=/var/lib/apt \ 
    apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy the built application and dependencies from the builder stage
# Use --from=<stage> to refer to files from the "builder" stage.
# The --chown flag ensures files are owned by the non-root user (node) in the final image.
COPY --from=builder --chown=node:node /app/dist ./dist 
COPY --from=builder --chown=node:node /app/node_modules ./node_modules 
COPY --from=builder --chown=node:node /app/package.json ./ 

# (Optional) Example of ADD instruction:
# ADD a tar archive into the image (automatically extracts if it's a local tar file).
# In this example, if there was a config.tar.gz in the build context, it would be extracted to /app/config/
# ADD config.tar.gz /app/config/

# Set ownership on the working directory (in case it was created by root)
# Ensure the 'node' user (provided by the Node.js image) owns all files
RUN mkdir -p /app/data && chown -R node:node /app

# Expose the application port (for documentation purposes).
# This does not actually publish the port, but notes that 3000 is intended for use.
EXPOSE 3000

# Define a mount point for volume (for any runtime data, logs, etc. that should persist or be shared)
VOLUME ["/app/data"]

# Switch to a non-root user for security (the 'node' user is built into the Node image)
USER node

# Define a health check to monitor the running container.
# Here we use curl to check the health endpoint of the app (or simply the main page) on port 3000.
# --interval=30s: check every 30 seconds, --timeout=5s: if no response in 5s consider it failed
# --start-period=5s: grace period before starting healthchecks, --retries=3: declare unhealthy after 3 fails
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \ 
  CMD curl -f http://localhost:3000/health || exit 1

# Set the system call signal used to stop the container (for graceful shutdown)
# By default, containers receive SIGTERM, but you can change it if needed.
STOPSIGNAL SIGTERM

# Entrypoint in exec form - defines the executable for the container
# Using "node" as the entrypoint means all commands will be launched via Node.js
ENTRYPOINT ["node"]

# Command in exec form - default application to run (can be overridden at runtime)
# Here it will run the app's main file (e.g., the compiled JS file in dist)
CMD ["dist/index.js"]

# (Optional) ONBUILD instruction: commands here execute when an image built FROM this image.
# This is useful if this Docker image will be used as a base for other images.
# For example, automatically populate /app when a child image is built.
ONBUILD COPY . /app
# (The ONBUILD above is just an example; it will trigger in child images built from this image.)
