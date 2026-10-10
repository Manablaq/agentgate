# AgentGate Reviewer Submission Summary

## Release status

**Progress 5/5 — reviewer evidence freeze and public release complete.**

AgentGate has completed all five fail-closed release gates.

The Progress 5 release is documentation/evidence-only: the deployed Intelligent
Contract source and generated schema remain byte-for-byte identical to the
frozen certified artifacts.

## Canonical deployment

- repository: `https://github.com/Manablaq/agentgate`
- branch: `main`
- network: GenLayer Studio Dev
- chain ID: `61997`
- RPC: `https://studio-dev.genlayer.com/api`
- contract: `0xedF4D6A3947386a56E4909c4079fF1737b139C6F`
- ConsensusMain: `0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575`
- contract SHA-256: `d00260687f7a5b832b173ea8b2a7635e102aca8ab5c56834b5650939ea084d6f`
- schema SHA-256: `251291df5a6d553cc3d171f1f00c80f980b138dcdb962b816e20b8ae7f5ac83d`

The certified Progress 5 release commit is
`0ac030b3b68550f8da0a845037d9e12b816af692`. R51 was the successful release
executor: it created the single authorized documentation/evidence commit,
performed the single non-force push, and verified local/public `main` parity.
R50 stopped before staging, commit, or push.

A Git commit cannot embed its own final SHA without changing that SHA. For that
reason, this document records the certified Progress 5 release commit above;
the current public `main` SHA is the GitHub branch head and is revalidated after
any documentation-only corrective commit.

## Live finality matrix

All release-gate cases finalized under normal multi-validator consensus; no case
is certified from leader-only output.

| # | Scenario | Request | Status | Vector | Decision |
| ---: | --- | --- | --- | --- | --- |
| 1 | Clearly authorized action | `request:1` | `RESOLVED` | `YN` | `AUTHORIZED` |
| 2 | Definite forbidden action | `request:2` | `RESOLVED` | `YY` | `BLOCKED` |
| 3 | Incomplete action | `request:3` | `RESOLVED` | `YU` | `REVIEW_REQUIRED` |
| 4 | Prompt injection | `request:4` | `RESOLVED` | `YN` | `AUTHORIZED` |
| 5 | Contradictory action | `request:5` | `RESOLVED` | `UU` | `REVIEW_REQUIRED` |
| 6 | Corrected revision | `request:6` | `RESOLVED` | `YN` | `AUTHORIZED` |

`request:6` has `parent_request_id = request:2`, proving the corrected-revision
path after a finalized blocked parent.

Final chain state:

- signer nonce: `15`
- mandate count: `1`
- request count: `6`

## Reviewer evidence

Tracked reviewer evidence is rooted at:

`evidence/progress4/MANIFEST.json`

The tracked manifest:

- contains repository-relative paths only
- binds each evidence artifact to its frozen SHA-256
- includes raw submission responses before decode
- includes transaction identities
- includes consensus/finality journals
- includes finalized transaction receipts
- includes per-write completion summaries
- includes the frozen matrix plan, payload manifest, fee envelope, recovery
  forensics/recovery plan, case-1 recovery result, remaining-case result and
  final live-state snapshot

Key frozen roots before the Progress 5 commit:

- Progress 4 matrix plan SHA-256:
  `68e77c4f9cd7189d4293ab0d76912aec44bddf6b31f359c786f0858198f9b797`
- Progress 4 execution payload manifest SHA-256:
  `5f0374dfb764e70809c68230485ae90970894fa36578bedbf3ce0e415ebf0290`
- Progress 4 fee envelope SHA-256:
  `bdb3048bcb767ac5d66571b0c7e430d85ce906be0fc11dccb2282043b6b3f568`
- Case-1 recovery result SHA-256:
  `52cad1249ad3c76043f9c4e2293d2c1a22fb3f98cb19402045db21933389878b`
- remaining five-case result SHA-256:
  `4162fd2426357be074eb044186048e2b873b4cec84eb3e6658d0dfcd13f825cc`
- reviewer-evidence source manifest SHA-256:
  `2bea68a85492c499eb69b80843b27df88f9fc9dfe59044e3b281070c9017e7dd`

## Recovery history

The original first `create_mandate` transaction finalized with an execution
error because its address argument had been encoded as a plain string. That
authorization was consumed and was never retried.

The recovery path corrected only the calldata address type, preserved the frozen
mandate semantics, and then completed Case 1 under finalized consensus. The
remaining five cases subsequently completed under the frozen matrix sequence.
Evidence for the failure, correction and successful recovery is retained under
`evidence/progress4/recovery/`.

## Release invariants

The Progress 5 release must preserve:

- contract SHA-256
  `d00260687f7a5b832b173ea8b2a7635e102aca8ab5c56834b5650939ea084d6f`
- schema SHA-256
  `251291df5a6d553cc3d171f1f00c80f980b138dcdb962b816e20b8ae7f5ac83d`
- six finalized live cases
- tracked-only evidence manifest
- zero secret-scan findings
- no force push or history rewrite

After this release, contract or evidence mutation requires a concrete reviewer
defect.
