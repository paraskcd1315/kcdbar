# Releases

Every version is bound to the commit it was cut from. `deploy/release.sh` appends a row here and
creates the matching annotated tag `v<version>`; neither is written by hand.

## What the three numbers mean

```
milestone . feature . fix
```

| Part | Bumped when | Resets |
|---|---|---|
| **milestone** | a milestone lands — the epics in `Backlog.md` (M1 the founding interaction, M2 the Dock replacement, M3 the Start menu, M4 customization, M5 polish) | feature and fix to 0 |
| **feature** | a major feature ships within the current milestone | fix to 0 |
| **fix** | bugs are fixed, in that feature or in an earlier one | — |

**A `0` milestone means nothing has landed yet**, which is why `0.0.1` is an alpha and the app says
so: `AppVersion.isPrerelease` is true while the first number is zero, and the About window draws the
ALPHA badge from it.

`VERSION` at the repo root holds the number and nothing else. `deploy/build.sh` refuses to compile a
version that is not three integers, so a malformed one can never reach a binary.

## Released

| Version | Commit | Date |
|---|---|---|
