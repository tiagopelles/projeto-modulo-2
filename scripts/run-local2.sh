#!/usr/bin/env bash
# Rodar localmente (precisa de docker, conftest|opa, syft, trivy, cosign e login no ghcr.io).
# Gera os artefatos que o sandbox não conseguiu produzir: SBOM do Syft, print do Trivy e assinatura keyless do Cosign.
set -euo pipefail
cd "$(dirname "$0")/.."
REG="${REG:-ghcr.io/tiagopelles}"
BEFORE="$REG/api-brinquedo:before"; AFTER="$REG/api-brinquedo:after"

echo "== 3. CADEIA (Cosign keyless) =="
docker push "$AFTER"
DIGEST=$(docker inspect --format '{{index .RepoDigests 0}}' "$AFTER")      # assina o DIGEST, não a tag
cosign sign --yes "$DIGEST"                                                  # abre o navegador (OIDC/Fulcio) e registra no Rekor
cosign attest --yes --type cyclonedx --predicate evidence/sbom-syft-after.cdx.json "$DIGEST"   # SBOM atestado
IDENT="${COSIGN_IDENTITY:-44900302+tiagopelles@users.noreply.github.com}"; ISS="${COSIGN_ISSUER:-https://github.com/login/oauth}"
cosign verify "$DIGEST" --certificate-identity "$IDENT" --certificate-oidc-issuer "$ISS" | tee evidence/cosign-verify-OK.txt

echo "== Ataque: tag adulterada (imagem trocada) =="
docker build -f Dockerfile.before -t "$AFTER" .           # atacante republica a MESMA tag com conteúdo diferente
docker push "$AFTER"
NEW=$(docker inspect --format '{{index .RepoDigests 0}}' "$AFTER")
cosign verify "$NEW" --certificate-identity "$IDENT" --certificate-oidc-issuer "$ISS" 2>&1 | tee evidence/cosign-verify-ADULTERADA.txt || echo "BLOQUEADO: sem assinatura válida"
