#!/usr/bin/env python3
"""Converte Dockerfile -> JSON no mesmo formato do conftest (para usar com `opa eval`)."""
import json, sys
out, buf = [], ""
for line in open(sys.argv[1]):
    s = line.strip()
    if not s or s.startswith("#"):
        continue
    buf += s.rstrip("\\")
    if s.endswith("\\"):
        continue
    cmd, _, rest = buf.partition(" ")
    out.append({"Cmd": cmd.lower(), "Value": rest.split()})
    buf = ""
print(json.dumps(out, indent=2))
