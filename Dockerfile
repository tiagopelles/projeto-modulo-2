FROM docker.io/library/node:22-bookworm-slim@sha256:4b150b48b4116e2a22f2c39cc27025fbf4f153e2078fd3b14d159fdb5c7279da
WORKDIR /app
COPY app-after/package*.json app-after/.npmrc ./
RUN npm ci --ignore-scripts --omit=dev
COPY app-after/ .
USER node
EXPOSE 3000
CMD ["node", "server.js"]
