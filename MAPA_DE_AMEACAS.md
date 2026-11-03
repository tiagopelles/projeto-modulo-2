# Mapa de ameaças — Raio-X da Cadeia de Suprimentos

Fases do modelo de ameaça da Aula 6: **Origem → Build → Distribuição** (+ confiança transitiva).

| Fase | Onde o atacante entra | Caso real (Aula 6) | Controle do curso | Bloqueia ou evidencia? | Neste projeto |
|---|---|---|---|---|---|
| Origem | Dockerfile/PR malicioso: `USER root`, base `:latest`, registry falso | XZ Utils (2024) | Policy as Code com Rego (Aulas 1-3) | **Bloqueia** no gate | `policy/dockerfile.rego` nega o `Dockerfile.before` com 3 violações |
| Build | Dependência vulnerável ou maliciosa (typosquatting, postinstall, dependency confusion) | ua-parser-js (2021), Codecov (2021) | `npm ci --ignore-scripts`, lockfile, `.npmrc`; SBOM + scanner (Aulas 4-6) | **Bloqueia** scripts; **evidencia** CVE | SBOM lista `lodash 4.17.15`; `npm audit`: 1 vulnerabilidade high (6 advisories) |
| Build | Base image mutável (tag republicada) | SolarWinds (2020): build comprometido | Imagem-base por **digest** (Aula 6) | **Bloqueia** (muda 1 byte, muda digest) | `FROM ...@sha256:2cf067...` |
| Distribuição | Imagem trocada no registry / mirror falso / tag reapontada | SolarWinds, ua-parser-js (conta roubada) | **Cosign keyless** + verificação por identidade (Aula 7) | **Bloqueia** no deploy se a verificação falhar; **evidencia** quem assinou e quando (Rekor) | `scripts/run-local.sh` seção 3; demo offline da mecânica em `evidence/verificacao-offline.txt` |
| Operação | CVE nova publicada depois do build | (fora dos 4 casos da aula) | SBOM x CVE contínuo (NIST SSDF RV.1.3) | **Evidencia** em minutos | `trivy sbom` sobre o SBOM guardado |

## Se essa cadeia fosse atacada amanhã, que evidência eu teria? (Aulas 8-9)

1. **O que rodava**: SBOM CycloneDX por imagem, atrelado ao digest. Respondo "lodash 4.17.15 estava em produção?" sem abrir o container.
2. **Quem produziu**: assinatura Cosign keyless com identidade OIDC (e-mail ou workflow) e certificado Fulcio de vida curta. Sem chave para roubar.
3. **Quando e que ninguém alterou o registro**: entrada no log de transparência Rekor, imutável e público. Dá a linha do tempo do incidente.
4. **O que era permitido**: a policy Rego versionada no Git é o critério de aceite. O histórico do repositório mostra qual regra valia em cada data e quem a mudou.
5. **O que estava exposto**: relatórios do Trivy datados (`evidence/trivy-*.txt`) mostram o que era conhecido no dia do build.

Lacuna honesta: sem proveniência SLSA (L2+) eu sei *quem assinou*, mas não *como foi construído*. O próximo passo é build em CI com `id-token: write` e atestação de proveniência.

Mapeamento: Rego → SSDF PO/PS; SBOM+Trivy → SSDF RV.1.3 e PW.4.1; Cosign → SSDF PS.2.1/PS.3.1 e SLSA L2.
