# AgentGate Progress 2 Local Certification

Date: 2026-10-09

## Result

**PASS — Progress 2/5 contract implementation and local certification is complete.**

This certificate closes the local certification gate only. It is not a Studio Dev
deployment certificate and is not live-network evidence.

## Frozen implementation

- implementation commit: `607f3d8bc4bc9d530a574106c10e978c405d6b1b`
- implementation tree: `fb9e81715accd8a16d2efbd7a7a75062ba060215`
- contract SHA256: `d00260687f7a5b832b173ea8b2a7635e102aca8ab5c56834b5650939ea084d6f`
- Direct Mode test SHA256: `881b69bbff06a794acf6eaa68a33331e0f8a21e390dcf74043b6ff5f01578e20`
- schema SHA256: `251291df5a6d553cc3d171f1f00c80f980b138dcdb962b816e20b8ae7f5ac83d`
- reproducible verifier SHA256: `9a5f6b8b1c7ed302e98fe44070b0afe50c5da41a038df44b3625ce41b18cbb17`

## Frozen runtime and toolchain

- target network: `studio-dev`
- target RPC: `https://studio-dev.genlayer.com/api`
- target chain ID: `61997`
- Studio release: `v0.123.0-rc.7`
- GenVM Manager: `v0.6.0-rc5`
- GenLayer CLI: `0.40.0-rc.3`
- Python: `3.12.14`
- `genlayer-py==0.19.0rc2`
- `genlayer-test==0.30.0rc2`
- `genvm-linter==0.11.1rc2`
- `pytest==8.4.2`
- `pyright==1.1.414`
- contract runner: `v0.3.0`
- `py-genlayer:5jycge4q8k23462jtb0b9fyey1s9qz928sz2nbrd9mg4sxqg2qng`
- Direct Mode pickling implementation: RC5 bundled `py-lib-cloudpickle`
  `3.1.0.dev0`

## Certification gates

- Python syntax: PASS
- strict all-surface typecheck: PASS
- GenVM lint: PASS
- GenVM validation: PASS
- schema generation: PASS
- schema reproducibility: PASS
- Direct Mode regression: PASS — 39 tests
- strict mocks: PASS
- pickling checks: PASS
- leader/validator agreement: PASS
- leader/validator disagreement: PASS
- malformed LLM output cases: PASS
- prompt-injection case: PASS
- ambiguous/UNKNOWN case: PASS
- contradictory proposal case: PASS
- replay protection: PASS
- designated-agent authorization: PASS
- revision invariants: PASS
- request lifecycle / double-resolution guard: PASS
- forbidden-surface scan: PASS
- public write surface: exactly `create_mandate`, `submit_action`,
  `resolve_action`

## Consensus implementation

The frozen RC5-compatible custom consensus primitive is
`gl.vm.run_nondet(leader_fn, validator_fn)`.

The leader validates model output and normalizes it to a compact `Y/N/U` vector.
The validator independently reruns the same classifier over the same immutable
mandate and exact submitted action and agrees only when its independently
derived compact vector exactly matches the leader vector.

The validator is fail-closed. Contract-level validator exceptions return
`False`; executor-level validator failure is consensus disagreement.

## Direct Mode compatibility notes

`genlayer-test==0.30.0rc2` auto-parses one JSON mock layer before the frozen RC5
SDK's `response_format="json"` decoder. The Direct Mode harness therefore
double-encodes mocked JSON payloads only. The production contract remains on
`response_format="json"` and is not changed by this test adapter.

The RC5 SDK's `run_nondet` annotation exposes an internal `Return[Unknown]` to
Pyright. The contract contains exactly one narrowly scoped
`reportUnknownMemberType` suppression at that SDK call site. All other contract
typing remains under `typecheck --strict --all`.

## Chain safety

- Studio Dev deployment performed: NO
- blockchain write performed: NO
- contract address: NOT YET ASSIGNED
- live finality certification: NOT YET PERFORMED

## Next gate

Progress 3/5 begins with a read-only Studio Dev pre-deployment revalidation.
Deployment must remain a separate controlled write after source/hash/account/
network checks and must never be blindly retried.
