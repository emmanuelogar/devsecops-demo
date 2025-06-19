# Build stage
FROM cgr.dev/chainguard/node:latest AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Ensure build can write to dist directory
RUN mkdir -p /app/dist && chmod -R 777 /app/dist

# Run the build (this executes as non-root already)
RUN npm run build

# Production stage (distroless)
FROM cgr.dev/chainguard/nginx:latest
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
