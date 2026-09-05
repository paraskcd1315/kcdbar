# Releases

Every version is bound to the commit it was cut from. `deploy/release.sh` appends a row here and
creates the matching annotated tag `v<version>`; neither is written by hand.

## What the three numbers mean

```
milestone . feature . fix
```

| Part | Bumped when | Resets |
|---|---|---|
| **milestone** | a milestone lands — the epics in `Backlog.md` (M1 the founding interaction, M2 the Dock replacement, M3 the Start menu, M4 customization, M5 polish) | feature and fix to 0 — `x.0.0` |
| **feature** | a major feature Paras asked for as a feature ships within the current milestone — one digit per feature that stands without cc-console | fix to 1 — `x.y.1` |
| **fix** | bugs are fixed, corrections are applied, UI is polished, or what already shipped is reworked, in that feature or in an earlier one | — |

**The fix digit is `0` only when the milestone changes** (Paras, 29-08-2026: *"the last number is never 0,
always starts from 1 … it is only 0 when the milestone changes"*). A feature release lands as `x.y.1`, a
milestone release as `x.0.0`. `0.0.1` was the first cut, and `0.3.1` follows it after three features.
`deploy/build.sh` refuses `x.y.0` when `y` is not `0`.

**The fix digit is the default.** Every release that carries bug fixes, corrections, UI polish or a rework of what already shipped bumps the third digit only, regardless of whether its tickets are stories.

**A `0` milestone means nothing has landed yet**, which is why `0.0.1` is an alpha and the app says
so: `AppVersion.isPrerelease` is true while the first number is zero, and the About window draws the
ALPHA badge from it.

`VERSION` at the repo root holds the number and nothing else. `deploy/build.sh` refuses to compile a
version that is not three integers, so a malformed one can never reach a binary.

## Released

| Version | Commit | Date |
|---|---|---|
| `0.3.1` | `fdc9633` (cut as `0f5491e`) | 2026-08-29 |
| `0.3.2` | `b86d1c5` (cut as `31527a6`) | 2026-08-29 |

The history was rewritten on 2026-08-29 so that every commit carries one author identity and no
co-author trailer; the ids changed and the trees did not. A dmg keeps the id of the tree it was cut
from, so `KCDBar-0.3.2-31527a6.dmg` is the build of what is now `b86d1c5`.
| `0.4.1` | `03f9514` | 2026-09-03 |
| `0.5.1` | `c4d18fb` | 2026-09-05 |
| `0.5.2` | `442cce9` | 2026-09-05 |
