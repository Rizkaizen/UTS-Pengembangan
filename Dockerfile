FROM nginx:1.27-alpine

# Copy the static website into Nginx's public directory.
COPY src/ /usr/share/nginx/html/

# Lightweight container health check.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

EXPOSE 80
