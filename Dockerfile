# DEPOIS: imagem-base por digest (Aula 6), deps travadas por lockfile, sem scripts, usuário não-root
# O digest vem do slide da Aula 6 (node:20-bookworm-slim); atualize com:
#   docker buildx imagetools inspect node:20-bookworm-slim
FROM docker.io/library/node:20-bookworm-slim@sha256:2cf067cfed83d5ea958367df9f966191a942351a2df77d6f0193e162b5febfc0
WORKDIR /app
COPY app-after/package*.json app-after/.npmrc ./
RUN npm ci --ignore-scripts --omit=dev
COPY app-after/ .
USER node
EXPOSE 3000
CMD ["node", "server.js"]
