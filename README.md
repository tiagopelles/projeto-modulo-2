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


# Correção de Vulnerabilidades e Validação do Pipeline

## Problema Identificado

A execução anterior do pipeline apresentou falha durante as etapas de validação e análise de segurança, impedindo a conclusão do fluxo de entrega.

**Execução com falha:**
- GitHub Actions Run: https://github.com/tiagopelles/projeto-modulo-2/actions/runs/41932475919

A falha estava relacionada às verificações automatizadas de vulnerabilidades existentes.

## Ajustes Realizados

Foram implementadas correções na branch de desenvolvimento para atender aos requisitos de segurança e qualidade definidos no pipeline, incluindo:

- Atualização de dependências com vulnerabilidades conhecidas.
- Adequação das versões de bibliotecas para versões seguras e suportadas.
- Revisão da imagem utilizada no processo de build.
- Ajustes no fluxo de análise de vulnerabilidades do pipeline.
- Validação do processo de build, testes e análise de segurança.

As configurações de análise consideram vulnerabilidades classificadas como **HIGH** e **CRITICAL**, permitindo a aprovação apenas quando não existirem vulnerabilidades críticas corrigíveis pendentes.

## Resultado

Após a implementação dos ajustes, uma nova execução do pipeline foi realizada com sucesso.

**Execução aprovada:**
- GitHub Actions Run: https://github.com/tiagopelles/projeto-modulo-2/actions/runs/42117374006

## Evidência

| Execução | Resultado |
|-----------|------------|
| 41932475919 | ❌ Falha |
| 42117374006 | ✅ Sucesso |

## Conclusão

Os ajustes aplicados na branch foram suficientes para atender às validações de segurança e qualidade estabelecidas no fluxo Gitflow Actions. A nova execução confirmou a correção das inconsistências identificadas anteriormente, resultando na conclusão bem-sucedida do pipeline e na aprovação das etapas automatizadas de build, testes e análise de vulnerabilidades.
