package main

import rego.v1

bad := [{"Cmd": "from", "Value": ["node:20"]}, {"Cmd": "cmd", "Value": ["node"]}]

good := [
	{"Cmd": "from", "Value": ["docker.io/library/node:20-bookworm-slim@sha256:2cf067cfed83d5ea958367df9f966191a942351a2df77d6f0193e162b5febfc0"]},
	{"Cmd": "user", "Value": ["node"]},
]

test_bad_is_denied if count(deny) == 3 with input as bad
test_good_passes if count(deny) == 0 with input as good
test_explicit_root_denied if {
	r := [{"Cmd": "user", "Value": ["root"]}]
	some m in deny with input as r
	contains(m, "USER root")
}
