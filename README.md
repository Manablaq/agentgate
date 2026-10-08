# AgentGate

Consensus Authorization Firewall for Autonomous AI Agents on GenLayer.

## Status

**Progress 2/5 — contract implementation and local certification in progress.**

Progress 1 architecture and threat-model freeze is complete.

The v1 Intelligent Contract and Direct Mode test harness are now implemented.
Studio Dev deployment has not occurred.

## Purpose

AgentGate lets a principal create an immutable natural-language authorization
mandate for a designated autonomous-agent address.

The agent submits an exact bounded action proposal. GenLayer validators
independently classify each mandate rule against that proposal as:

- `YES`
- `NO`
- `UNKNOWN`

A custom `gl.vm.run_nondet` leader/validator path compares only the
independently derived compact decision vector. Deterministic contract code then
returns:

- `AUTHORIZED`
- `BLOCKED`
- `REVIEW_REQUIRED`

The LLM never directly controls the final authorization decision.

## Consensus rule

The leader validates and normalizes LLM output to a compact `Y/N/U` vector.

Each validator independently reruns the same classification from the same
immutable mandate rules and exact submitted action. The validator accepts only
when its independently derived vector exactly matches the leader vector.

Storage mutation occurs only after the consensus block returns.

## Target

- GenLayer Studio development preview / Studio Next preview
- RPC: `https://studio-dev.genlayer.com/api`
- Chain ID: `61997`
- Studio: `v0.123.0-rc.7`
- GenVM Manager: `v0.6.0-rc5`
- GenLayer CLI: `0.40.0-rc.3`
- contract runner: `v0.3.0`

Exact package and runner pins are frozen in `toolchain-freeze.json`.

## v1 safety scope

AgentGate v1 deliberately has:

- no web access
- no external API dependency
- no EVM calls
- no cross-contract calls
- no token or native-value transfers
- no randomness
- no off-chain database
- no admin override
- no mandate mutation
- no decision override
- no action execution

It is an authorization judgment protocol, not an execution engine.

## Verify

```bash
./scripts/verify_backend.sh
```

## Release progress

1. Research + architecture + threat-model freeze — **complete**
2. Contract implementation + local certification — **in progress**
3. Studio Dev deployment — pending
4. Live multi-validator/finality matrix — pending
5. Reviewer evidence freeze + submission — pending

See:

- `docs/RESEARCH_FREEZE.md`
- `docs/ARCHITECTURE_FREEZE.md`
- `docs/THREAT_MODEL.md`
- `docs/RELEASE_GATES.md`
- `toolchain-freeze.json`
