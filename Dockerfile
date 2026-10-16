FROM --platform=$BUILDPLATFORM ghcr.io/getzola/zola:v0.23.6 AS source

WORKDIR /site
COPY . .

# Build the production site using zola.toml's base_url.
FROM source AS production-build

RUN ["/zola", "build"]

# Build a local preview with URLs pointing to localhost.
FROM source AS local-build

RUN ["/zola", "build", "--base-url", "http://localhost:8080"]

# Shared nginx configuration.
FROM nginx:stable-alpine AS runtime

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Select this target explicitly for local testing.
FROM runtime AS local

COPY --from=local-build /site/public/ /usr/share/nginx/html/

# The final stage is the default, so CI builds production.
FROM runtime AS production

COPY --from=production-build /site/public/ /usr/share/nginx/html/