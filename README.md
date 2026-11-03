# Raio-X da Cadeia de Suprimentos (Projeto Final CY-SE-013)

App de brinquedo (Node + `lodash@4.17.15`, vulnerável de propósito) em duas versões:

| | ANTES | DEPOIS |
|---|---|---|
| Dockerfile | `Dockerfile.before` (`node:20`, root, `npm install`) | `Dockerfile` (digest, `USER node`, `npm ci --ignore-scripts`) |
| Código | `app/` (lodash 4.17.15) | `app-after/` (lodash 4.18.1) |

## Checklist de avaliação — o que está PRONTO e o que falta rodar
| Item | Estado | Onde |
|---|---|---|
| Policy Rego escrita e testada | **Executado** (motor Rego `regopy`, 4 casos); `dockerfile_test.rego` escrito mas NÃO executado aqui. Rode `conftest`/`opa test` localmente para confirmar | `policy/`, `evidence/rego-resultado.txt` |
| SBOM | **Executado** (CycloneDX 1.5 via `cyclonedx-npm`). Syft/imagem: rode o script | `evidence/sbom.cdx.json`, `sbom-after.cdx.json` |
| 1 vulnerabilidade real | **Executado com `npm audit`** (lodash, 1 high / 6 advisories). Print do **Trivy**: rode o script | `evidence/npm-audit-BEFORE.txt` |
| Assinatura/verificação Cosign | **NÃO executado** (sandbox sem Docker, Sigstore e registry). Demo offline da mecânica com openssl, que **não é Cosign** | `evidence/verificacao-offline.txt` |
| Caso real conectado | Escrito | `MAPA_DE_AMEACAS.md` |

Para fechar os itens pendentes, rode `scripts/run-local.sh` (ajuste `REG`, `COSIGN_IDENTITY`).
