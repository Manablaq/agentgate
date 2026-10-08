# AgentGate

Consensus Authorization Firewall for Autonomous AI Agents on GenLayer.

## Status

**Progress 1/5 — architecture and threat-model freeze candidate prepared.**

No Intelligent Contract has been implemented or deployed yet.

## Purpose

AgentGate lets a principal create an immutable natural-language authorization
mandate for a designated autonomous-agent address.

The agent submits an exact bounded action proposal. GenLayer validators
independently classify each mandate rule against that proposal as:

- `YES`
- `NO`
- `UNKNOWN`

A custom leader/validator consensus path compares only the independently derived
compact decision vector. Deterministic contract code then returns:

- `AUTHORIZED`
- `BLOCKED`
- `REVIEW_REQUIRED`

The LLM never directly controls the final authorization decision.

## Target

- GenLayer Studio development preview / Studio Next preview
- RPC: `https://studio-dev.genlayer.com/api`
- Chain ID: `61997`
- Network preset: `studio-dev`

Exact release-candidate package and runner pins will be discovered and frozen in
Progress 2 rather than guessed in advance.

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

## Release progress

1. Research + architecture + threat-model freeze — **current**
2. Contract implementation + local certification — pending
3. Studio Dev deployment — pending
4. Live multi-validator/finality matrix — pending
5. Reviewer evidence freeze + submission — pending

See:

- `docs/RESEARCH_FREEZE.md`
- `docs/ARCHITECTURE_FREEZE.md`
- `docs/THREAT_MODEL.md`
- `docs/RELEASE_GATES.md`
