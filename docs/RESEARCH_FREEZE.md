# AgentGate Research Freeze

## Purpose

This document freezes the external GenLayer assumptions used to design AgentGate
before contract implementation begins.

## Target environment

AgentGate targets the GenLayer Studio development preview / Studio Next preview.

Canonical integration target:

- RPC: `https://studio-dev.genlayer.com/api`
- Chain ID: `61997`
- Network preset: `studio-dev`
- Explorer: `https://explorer-studio-dev.genlayer.com`

The browser-facing Studio Next name must not be used to relabel another network.
The canonical RPC and chain ID above remain the integration identity.

Studio Dev is a release-candidate preview and may be reset. Persistent reviewer
evidence therefore must be copied into the repository after live certification.

## Toolchain rule

The exact CLI, SDK, linter, test framework, runner dependency and Studio release
pins are deliberately not guessed at Progress 1.

Progress 2 must discover the locally installed compatible release-candidate
toolchain, verify it against the target Studio release, and freeze the exact
versions/hashes before contract certification.

Do not substitute the stable Studionet preset. Studionet uses a different chain.

## Consensus rule

AgentGate contains LLM classification, so exact-equality consensus over raw LLM
responses is forbidden.

The frozen consensus design is:

1. The deterministic path copies the stored mandate rules and action text into
   ordinary in-memory values.
2. `leader_fn` asks an LLM to classify every rule as `YES`, `NO`, or `UNKNOWN`.
3. The leader output is validated and normalized to a compact `Y` / `N` / `U`
   decision vector.
4. `validator_fn` independently reruns the same classification from the same
   mandate rules and action.
5. The validator validates and normalizes its own answer.
6. Consensus compares only the compact decision vector.
7. The accepted vector returns to deterministic contract code.
8. Deterministic code computes `AUTHORIZED`, `BLOCKED`, or `REVIEW_REQUIRED`
   and only then mutates storage.

Implementation target: `gl.vm.run_nondet_unsafe(leader_fn, validator_fn)`.

The validator must never accept a leader result merely because its JSON shape is
valid. It must independently derive the rule decisions.

## Nondeterministic-block restrictions

No storage mutation, contract call, message emission, or deterministic state
transition may occur inside a nondeterministic block.

Only the agreed classification result crosses back into deterministic code.

## Deliberately excluded v1 dependencies

AgentGate v1 will not depend on:

- web access
- external APIs
- EVM contract execution
- cross-contract calls
- token transfers
- native-value transfers
- randomness
- timestamps as authorization evidence
- off-chain databases
- secrets
- mutable administrator policy
- upgrade authority
- action execution

AgentGate judges authorization only. It does not execute the proposed action.

This keeps live certification focused on GenLayer's LLM consensus and state
finality rather than unrelated external dependencies.
