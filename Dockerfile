FROM docker.io/library/node:26-alpine3.23@sha256:a004f02badb10f7037f1bede5cc916131d3f62a1690a92845457949740e86117
WORKDIR /app
COPY app-after/package*.json app-after/.npmrc ./
RUN npm ci --ignore-scripts --omit=dev
COPY app-after/ .
USER node
EXPOSE 3000
CMD ["node", "server.js"]
