# Raio-X da Cadeia de Suprimentos (Projeto Final CY-SE-013)

Mostra o contraste **antes e depois** em uma app de brinquedo (Node + `lodash@4.17.15`, vulnerável de propósito):
sem controles, a imagem é aceita; com os controles do curso, o problema é bloqueado ou evidenciado.

| | ANTES | DEPOIS |
|---|---|---|
| Dockerfile | `Dockerfile.before` (`node:20`, root, `npm install`) | `Dockerfile` (base por digest, `USER node`, `npm ci --ignore-scripts`) |
| Código | `app/` (lodash 4.17.15) | `app-after/` (lodash 4.18.1) |
| Policy Rego | Negada: 3 violações | Aprovada: 0 violações |
| Assinatura Cosign | Sem assinatura: verificação falha | Assinada por digest: verificação passa |

## Estrutura
```
Dockerfile.before        # ANTES
Dockerfile               # DEPOIS
app/  app-after/         # app com lodash vulnerável e corrigido
policy/dockerfile.rego   # regra Rego (formato conftest)
policy/dockerfile_test.rego
scripts/run-local.sh     # roda tudo de ponta a ponta
scripts/dockerfile2json.py
evidence/                # SBOMs, Trivy, npm audit, Cosign
MAPA_DE_AMEACAS.md       # mapa de ameaças + resposta de compliance
```

## Checklist de avaliação
| Item | Estado | Evidência |
|---|---|---|
| Escreveu e testou a policy Rego | Executado | `policy/`, `evidence/rego-resultado.txt` |
| Gerou o SBOM | Executado (cyclonedx-npm e Syft) | `evidence/sbom.cdx.json`, `evidence/sbom-syft-before.cdx.json`, `evidence/sbom-syft-after.cdx.json` |
| Encontrou e registrou 1 vulnerabilidade real | Executado (Trivy e `npm audit`: lodash 4.17.15) | `evidence/trivy-BEFORE.txt`, `evidence/npm-audit-BEFORE.txt` |
| Assinou e verificou com Cosign | Executado (keyless, ghcr.io) | `evidence/cosign-verify-OK.txt`, `evidence/cosign-verify-ADULTERADA.txt` |
| Conectou com caso real de ataque | Escrito (SolarWinds, XZ Utils, ua-parser-js, Codecov) | `MAPA_DE_AMEACAS.md` |
