#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV_BIN="$ROOT/.venv/bin"
PYTHON="$VENV_BIN/python"
LINTER="$VENV_BIN/genvm-lint"
PYTEST="$VENV_BIN/pytest"
CONTRACT="$ROOT/contracts/agent_gate.py"
TESTS="$ROOT/tests/direct"
SCHEMA="$ROOT/schema/agent_gate.schema.json"
GENVM_VERSION_PIN="v0.6.0-rc5"
PY_GENLAYER_HASH="5jycge4q8k23462jtb0b9fyey1s9qz928sz2nbrd9mg4sxqg2qng"

export PATH="$VENV_BIN:$PATH"
export GENVM_VERSION="$GENVM_VERSION_PIN"

test -x "$PYTHON"
test -x "$LINTER"
test -x "$VENV_BIN/pyright"
test -x "$PYTEST"
test -f "$CONTRACT"
test -f "$SCHEMA"

CLOUDPICKLE_ROOT_FILE="$(mktemp)"
TMP_SCHEMA="$(mktemp)"

cleanup() {
  rm -f "$CLOUDPICKLE_ROOT_FILE" "$TMP_SCHEMA"
}
trap cleanup EXIT

PY_GENLAYER_HASH_ENV="$PY_GENLAYER_HASH" \
GENVM_VERSION_ENV="$GENVM_VERSION_PIN" \
CLOUDPICKLE_ROOT_FILE_ENV="$CLOUDPICKLE_ROOT_FILE" \
"$PYTHON" - <<'PYCLOUD'
from pathlib import Path
import os
from genvm_linter.validate import artifacts

version = os.environ["GENVM_VERSION_ENV"]
py_hash = os.environ["PY_GENLAYER_HASH_ENV"]
out = Path(os.environ["CLOUDPICKLE_ROOT_FILE_ENV"])

bundle = artifacts.get_tarball_path(version)
py_runner = artifacts.extract_runner(bundle, "py-genlayer", py_hash)
deps = artifacts.parse_runner_manifest(py_runner)
cp_hash = deps.get("py-lib-cloudpickle")
if not cp_hash:
    raise SystemExit("missing py-lib-cloudpickle dependency")

cp_runner = artifacts.extract_runner(
    bundle,
    "py-lib-cloudpickle",
    cp_hash,
)

matches = sorted(cp_runner.rglob("cloudpickle/__init__.py"))
if len(matches) != 1:
    raise SystemExit(
        f"expected one cloudpickle package, found {len(matches)}"
    )

source = matches[0].read_text()
if '__version__ = "3.1.0.dev0"' not in source:
    raise SystemExit("unexpected frozen cloudpickle version")

out.write_text(str(matches[0].parent.parent))
PYCLOUD

CLOUDPICKLE_ROOT="$(cat "$CLOUDPICKLE_ROOT_FILE")"
test -d "$CLOUDPICKLE_ROOT/cloudpickle"

export PYTHONPATH="$CLOUDPICKLE_ROOT${PYTHONPATH:+:$PYTHONPATH}"

test "$("$PYTHON" -c 'import cloudpickle; print(cloudpickle.__version__)')" = "3.1.0.dev0"

"$PYTHON" -m py_compile \
  "$CONTRACT" \
  "$ROOT/tests/direct/test_agent_gate.py"

"$LINTER" typecheck "$CONTRACT" --strict --all
"$LINTER" check "$CONTRACT"
"$PYTEST" "$TESTS" -q

"$LINTER" schema "$CONTRACT" --output "$TMP_SCHEMA"
cmp -s "$SCHEMA" "$TMP_SCHEMA" || {
  echo "STOP: tracked schema is not reproducible from frozen contract/toolchain" >&2
  exit 1
}
