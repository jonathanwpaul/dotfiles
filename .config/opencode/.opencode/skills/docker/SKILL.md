---
name: docker
description: Docker and docker compose patterns, common aliases, debugging containers
---

## Aliases in use

```bash
dcu   # docker compose up -d
dcd   # docker compose down
dcl   # docker compose logs
dcp   # docker container prune
dip   # docker image prune
dps   # docker ps -a
```

## compose.yml conventions

- Use `compose.yml` (not `docker-compose.yml`)
- Always pin image versions — never use `latest` in production
- Use named volumes for persistent data, bind mounts for dev source
- Health checks on services that other services depend on

```yaml
services:
  api:
    build: .
    depends_on:
      db:
        condition: service_healthy
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/mydb

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

## Dockerfile best practices

```dockerfile
# Use specific version, slim variant
FROM node:20-alpine AS base

# Dependencies as a separate layer (cache-friendly)
FROM base AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Build
FROM base AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Final minimal image
FROM base AS final
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
USER node
CMD ["node", "dist/index.js"]
```

## Debugging

```bash
# Shell into running container
docker exec -it <container> sh

# Shell into a stopped container
docker run --rm -it --entrypoint sh <image>

# Follow logs for specific service
docker compose logs -f api

# Inspect network
docker network inspect <network>

# Check resource usage
docker stats
```
