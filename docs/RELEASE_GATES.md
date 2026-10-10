# AgentGate Release Gates

The project uses five fail-closed progress gates.

## Progress 1/5 — Research, architecture and threat-model freeze

Required:

- public repository exists
- canonical target network frozen
- consensus pattern frozen
- mandate grammar frozen
- state machine frozen
- deterministic decision algorithm frozen
- v1 public surface frozen
- excluded dependencies documented
- threat model documented

No contract source or blockchain write is allowed in this gate.

## Progress 2/5 — Contract implementation and local certification

Required before deployment:

- exact Studio-compatible toolchain discovered and pinned
- exact contract runner dependency pinned
- Intelligent Contract implemented
- schema generated
- linter validation passes
- combined checks pass
- strict typecheck passes
- Direct Mode tests pass
- strict mocks enabled
- pickling checks enabled
- leader/validator agreement tested
- leader/validator disagreement tested
- malformed LLM output tested
- prompt injection tested
- ambiguous and contradictory proposals tested
- replay, authorization, revision and lifecycle invariants tested
- forbidden-surface scan passes
- contract SHA256 frozen
- schema SHA256 frozen

No deployment until every local gate passes.

## Progress 3/5 — Studio Dev deployment

Required:

- pre-deployment account/network revalidation
- canonical RPC is Studio Dev
- chain ID is 61997
- frozen source hash revalidated immediately before deployment
- exactly one controlled deployment
- deployment transaction identity persisted before polling
- contract address recorded
- deployed-source parity proven
- no blind deployment retry

## Progress 4/5 — Live multi-validator/finality matrix

At minimum certify finalized cases for:

1. clearly authorized action
2. definite forbidden action
3. incomplete action -> review required
4. prompt injection
5. contradictory action -> review required
6. corrected revision of a blocked/review-required request

For every case preserve:

- exact mandate
- exact action
- client nonce
- raw transaction response before decoding
- transaction identity
- consensus progression
- finalized receipt
- final request state
- final decision vector
- final deterministic decision

Do not certify from leader-only output.

## Progress 5/5 — Reviewer evidence freeze and submission

Required:

- all live cases finalized
- frozen contract/source/schema hashes unchanged
- immutable evidence copied into repository
- release metadata updated to current state
- manifest references tracked files only
- secret scan passes
- public repository audit passes
- current README and reviewer submission summary agree
- certified Progress 5 release commit recorded and current public `main` parity verified

After Progress 5, no contract or evidence mutation is allowed unless a reviewer
identifies a concrete defect.

## Certified release status

The five release gates are certified complete for the public AgentGate release:

1. Progress 1/5 — complete
2. Progress 2/5 — complete
3. Progress 3/5 — complete
4. Progress 4/5 — complete
5. Progress 5/5 — complete

Progress 4 finalized all six required multi-validator cases. The tracked
reviewer evidence is rooted at `evidence/progress4/MANIFEST.json`.

The contract and schema remain frozen at:

- contract SHA-256:
  `d00260687f7a5b832b173ea8b2a7635e102aca8ab5c56834b5650939ea084d6f`
- schema SHA-256:
  `251291df5a6d553cc3d171f1f00c80f980b138dcdb962b816e20b8ae7f5ac83d`

The certified Progress 5 release commit is
`0ac030b3b68550f8da0a845037d9e12b816af692`. R51 performed the single
authorized non-force push and verified local/public `main` parity; R50 stopped
before staging, commit, or push. Because a Git commit cannot embed its own SHA
without changing it, the release commit is recorded here while the current
public `main` SHA is the GitHub branch head and is revalidated after any
documentation-only corrective commit.
