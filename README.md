# AgentGate

Consensus Authorization Firewall for Autonomous AI Agents on GenLayer.

## Status

Repository initialized. Architecture and threat-model freeze are the next gate.

No Intelligent Contract has been deployed yet.

## Purpose

AgentGate will let a principal register an immutable authorization mandate and
submit proposed autonomous-agent actions for GenLayer validator consensus.

Validators will classify bounded mandate rules against a proposed action using a
small normalized outcome surface. Deterministic contract logic will then produce
one of:

- `AUTHORIZED`
- `BLOCKED`
- `REVIEW_REQUIRED`

The LLM will not directly control the final authorization decision.

## Target

GenLayer Studio Dev / Studio Next preview.

## Repository discipline

Contract source, tests, live evidence, deployment identity, and release metadata
will be frozen and independently verifiable before reviewer submission.
