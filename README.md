# AgentGate

Consensus Authorization Firewall for Autonomous AI Agents on GenLayer.

## Status

**Progress 5/5 — reviewer evidence freeze and public release complete.**

All five fail-closed release gates are complete. The deployed Studio Dev contract
was verified against the frozen source, and the six-case live
multi-validator/finality matrix finalized with the expected deterministic
decisions.

## Deployment

- network: GenLayer Studio Dev
- RPC: `https://studio-dev.genlayer.com/api`
- chain ID: `61997`
- contract: `0xedF4D6A3947386a56E4909c4079fF1737b139C6F`
- ConsensusMain: `0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575`
- contract SHA-256: `d00260687f7a5b832b173ea8b2a7635e102aca8ab5c56834b5650939ea084d6f`
- schema SHA-256: `251291df5a6d553cc3d171f1f00c80f980b138dcdb962b816e20b8ae7f5ac83d`

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

## Final live matrix

| Case | Request | Final vector | Final decision |
| --- | --- | --- | --- |
| Clearly authorized | `request:1` | `YN` | `AUTHORIZED` |
| Definite forbidden | `request:2` | `YY` | `BLOCKED` |
| Incomplete | `request:3` | `YU` | `REVIEW_REQUIRED` |
| Prompt injection | `request:4` | `YN` | `AUTHORIZED` |
| Contradictory | `request:5` | `UU` | `REVIEW_REQUIRED` |
| Corrected revision | `request:6` | `YN` | `AUTHORIZED` |

`request:6` is the corrected revision of blocked `request:2` and preserves
`parent_request_id = request:2`.

Final live state:

- signer nonce: `15`
- mandate count: `1`
- request count: `6`
- all six requests: `RESOLVED`

## Reviewer evidence

The immutable tracked evidence set is rooted at
`evidence/progress4/MANIFEST.json`.

The manifest binds every copied reviewer-evidence artifact to its frozen
SHA-256 and references repository-tracked paths only. The final public release
SHA is the `main` commit containing this README; the release executor verifies
local/public `main` parity after the non-force push and records that exact SHA
in its post-push release-verification artifact.

See `docs/REVIEWER_SUBMISSION_SUMMARY.md` for the reviewer-facing release
summary.

## Target and pinned toolchain

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
2. Contract implementation + local certification — **complete**
3. Studio Dev deployment — **complete**
4. Live multi-validator/finality matrix — **complete**
5. Reviewer evidence freeze + submission preparation — **complete**

See:

- `docs/RESEARCH_FREEZE.md`
- `docs/ARCHITECTURE_FREEZE.md`
- `docs/THREAT_MODEL.md`
- `docs/RELEASE_GATES.md`
- `docs/PROGRESS_2_LOCAL_CERTIFICATION.md`
- `docs/REVIEWER_SUBMISSION_SUMMARY.md`
- `evidence/progress4/MANIFEST.json`
- `toolchain-freeze.json`
