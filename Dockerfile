# ---- Base Node ----
FROM node:20 AS base
WORKDIR /app

# ---- Frontend ----
FROM base AS front-end
WORKDIR /app/front-end
COPY front-end/package*.json ./
RUN npm install
COPY front-end ./
RUN npm run build

# ---- Backend ----
FROM base AS back-end
WORKDIR /app/back-end
COPY back-end/package*.json ./
RUN npm install
COPY back-end ./
RUN npm run build

# ---- Release ----
FROM node:20-slim AS release
WORKDIR /app
COPY --from=front-end /app/client ./client
COPY --from=back-end /app/back-end/dist ./back-end/dist
COPY back-end/package*.json ./
RUN npm install --omit=dev
EXPOSE 3000
CMD [ "node", "back-end/dist/main" ]