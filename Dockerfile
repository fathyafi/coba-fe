# # Stage 1: Build Vue app
# FROM node:18 AS build-stage
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # Stage 2: Serve with nginx
# FROM nginx:alpine
# COPY --from=build-stage /app/dist /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build Vue.js app
FROM node:18 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with nginx (non-root friendly)
FROM nginxinc/nginx-unprivileged:alpine

# Copy dist to nginx html
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Use custom config if needed
COPY nginx.conf /etc/nginx/conf.d/default.conf

# User already set to nginx (UID 101) in nginx-unprivileged
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]