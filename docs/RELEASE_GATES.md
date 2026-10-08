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
- final public `main` SHA recorded

After Progress 5, no contract or evidence mutation is allowed unless a reviewer
identifies a concrete defect.
