# AgentGate Architecture Freeze

## Protocol statement

AgentGate is a consensus authorization firewall for autonomous AI agents.

A principal creates an immutable mandate for one designated agent address. The
agent submits a bounded natural-language action proposal. GenLayer validators
independently classify whether the proposal satisfies or violates each mandate
rule. Deterministic contract logic converts the agreed classification vector
into a final authorization decision.

The LLM never directly chooses the final authorization decision.

## Actors

### Principal

Creates a mandate and permanently defines:

- mandate title
- designated agent address
- bounded ordered rule set

A mandate cannot be edited or deleted.

### Designated agent

The only address allowed to submit action requests under that mandate.

### Resolver

Any account may sponsor resolution of an open request. Resolver identity cannot
change the mandate, action, vector, or deterministic final decision.

## Immutable mandate grammar

A mandate contains 1 through 8 ordered rules.

Each rule has exactly:

```json
{
  "text": "Natural-language proposition to evaluate against the proposed action.",
  "mode": "REQUIRE"
}
```

`mode` is exactly one of:

- `REQUIRE`
- `FORBID`

Interpretation:

- `REQUIRE`: the proposition must evaluate to `YES`.
- `FORBID`: the proposition must evaluate to `NO`.

The rule text is always treated as untrusted data, never as an instruction that
can modify the evaluator's system rules.

## Action request

A request permanently records:

- request ID
- mandate ID
- designated-agent submitter
- exact action text
- client nonce
- optional parent request ID
- status
- agreed rule vector
- final decision
- resolver address when resolved

The exact action text is frozen at submission.

## Replay rule

`agent_address + client_nonce` is unique.

A previously used nonce for that agent cannot be reused.

## Revision rule

A request may reference a parent request only when all are true:

- parent exists
- parent belongs to the same mandate
- parent submitter is the same designated agent
- parent is already resolved

A revision creates a new immutable request. It never modifies the parent.

## State machine

Request state:

```text
OPEN -> RESOLVED
```

No reopening and no second resolution.

## Validator output

For each mandate rule, the evaluator returns exactly one semantic classification:

- `YES`: the action clearly supports / contains the rule proposition.
- `NO`: the action clearly contradicts / excludes the rule proposition.
- `UNKNOWN`: the action is insufficient, ambiguous, contradictory, or does not
  allow a reliable determination.

The implementation normalizes these to:

- `Y`
- `N`
- `U`

No free-form reasoning is authoritative contract state.

## Consensus algorithm

The leader and every validator independently evaluate the same immutable rule
texts and action text.

Leader flow:

```text
rules + action
    -> LLM structured classification
    -> strict schema validation
    -> compact Y/N/U vector
```

Validator flow:

```text
same rules + same action
    -> independent LLM structured classification
    -> strict schema validation
    -> compact Y/N/U vector
    -> compare vector with leader vector
```

The validator accepts only when the independently derived decision vector
matches the leader vector exactly.

The intended GenLayer primitive is a custom
`gl.vm.run_nondet_unsafe(leader_fn, validator_fn)` pair.

## Deterministic authorization algorithm

For each rule:

### REQUIRE

- `Y` = satisfied
- `N` = definite violation
- `U` = uncertain

### FORBID

- `N` = satisfied
- `Y` = definite violation
- `U` = uncertain

Final decision:

```text
if any definite violation:
    BLOCKED
else if any UNKNOWN:
    REVIEW_REQUIRED
else:
    AUTHORIZED
```

A definite violation dominates uncertainty.

## Public write surface

Target v1 write methods:

```text
create_mandate(...)
submit_action(...)
resolve_action(...)
```

No other state-mutating method is part of v1.

## Public view surface

Target v1 views:

```text
get_mandate_count()
get_request_count()
get_mandate(...)
get_request(...)
get_action(...)
get_limits()
version()
```

A separate certificate object is unnecessary in v1 because a resolved request
itself is the immutable authorization certificate.

## Bounds

Exact constants will be frozen with the contract in Progress 2, but the
architecture requires explicit upper bounds for:

- title length
- rule count
- rule text length
- serialized rule specification
- action text length
- client nonce length

Unbounded user-controlled strings are forbidden.

## No execution authority

`AUTHORIZED` means only:

> Under this immutable mandate and this exact submitted action text, the
> finalized GenLayer consensus result satisfies the authorization rules.

AgentGate does not execute transactions, sign messages, transfer assets, call
external contracts, or assert that an off-chain agent actually followed the
authorized proposal.
