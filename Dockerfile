FROM docker.io/library/node:22-bookworm-slim@sha256:<DIGEST_NOVO> AS deps
WORKDIR /app
COPY app-after/package*.json app-after/.npmrc ./
RUN npm ci --ignore-scripts --omit=dev

FROM docker.io/library/node:22-bookworm-slim@sha256:<DIGEST_NOVO>
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app-after/ .
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
USER node
EXPOSE 3000
CMD ["node", "server.js"]
