# Policy as Code (Aulas 1-3). Formato do conftest para Dockerfile:
# input é uma lista de instruções [{"Cmd": "from", "Value": ["node:20"]}, ...]
package main

import rego.v1

approved_registries := {"docker.io/library/", "registry.empresa.com.br/"}

# Regra 1: o container NÃO pode rodar como root (sem USER ou USER root)
deny contains msg if {
	not has_user
	msg := "container roda como root: falta instrução USER não-root"
}

deny contains msg if {
	some i
	input[i].Cmd == "user"
	lower(input[i].Value[0]) == "root"
	msg := "container roda como root: USER root"
}

# Regra 2: imagem-base precisa vir de registry aprovado e fixada por digest
deny contains msg if {
	some i
	input[i].Cmd == "from"
	img := input[i].Value[0]
	not contains(img, "@sha256:")
	msg := sprintf("imagem-base '%s' não está fixada por digest (@sha256)", [img])
}

deny contains msg if {
	some i
	input[i].Cmd == "from"
	img := input[i].Value[0]
	not approved(img)
	msg := sprintf("imagem-base '%s' não é de um registry aprovado", [img])
}

has_user if {
	some i
	input[i].Cmd == "user"
}

approved(img) if {
	some prefix in approved_registries
	startswith(img, prefix)
}
