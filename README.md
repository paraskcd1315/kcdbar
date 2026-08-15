# KCDBar

A Windows-style, deeply customizable **taskbar and Start menu for macOS 26** that replaces the Dock.

The macOS Dock cannot minimize a window. On Windows a taskbar button is a toggle — click it while the
window is in front and it minimizes, click again and it returns focused. That single missing
interaction is what this exists for; everything else is so the Dock can be hidden for good.

Windows-style is the default, not the ceiling: a Dock-like preset is a first-class target, because the
customization is the product.

## Status

Foundation. Research done, specs written, repo scaffolded, Liquid Glass probe in place. No product
features yet.

- **Jira**: [KCDBAR](https://paraskcd.atlassian.net/jira/software/projects/KCDBAR)
- **Specs**: [KCDBAR Confluence space](https://paraskcd.atlassian.net/wiki/spaces/KCDBAR)

## Requirements

| | |
|---|---|
| macOS | 26.0 or later, Apple Silicon |
| Xcode | 26.x |
| XcodeGen | any recent release; the `XCODEGEN` env var overrides its path |

The app is **non-sandboxed** and **not notarized**, and it will not be distributed through the App
Store — hiding the Dock requires writing another application's preference domain, which the sandbox
forbids.

## Building

```sh
./deploy/create-signing-identity.sh   # once per machine, needs a password prompt
./deploy/build.sh                     # generate, build, verify the signature
./deploy/run.sh                       # build, then relaunch
```

`KCDBar.xcodeproj` is generated from `project.yml` and is gitignored — **never hand-author it**.

### Why the signing step is not optional

macOS ties the Accessibility grant to the signature's designated requirement. **Ad-hoc signing has no
stable designated requirement, so every rebuild looks like a new app and the grant is lost.** The
self-signed `KCDBar Local` certificate keeps that identity constant across builds. `codesign -d -r-`
should show the designated requirement pinned to the certificate hash.

`ENABLE_HARDENED_RUNTIME` stays `NO`: with a self-signed certificate, library validation would demand
a Team ID the signature has not got, and the app would not launch.

## Layout

```
Sources/
  App/          entry point, delegate, scene composition
  Shared/
    Domain/     entities, interfaces, use cases — no framework imports
    Data/       service implementations
    Presentation/
    Core/
    Ui/Theme/   colour, spacing, radii, motion, type tokens
    Ui/Ds/      design system in atomic tiers
  Platform/     the ONLY place that imports AppKit
Resources/      Localizable.xcstrings, assets
deploy/         build, sign, run
```

`Shared` never imports AppKit. Every platform capability is a protocol in `Domain/…/Interfaces`,
implemented once in `Platform`.

## Conventions

One type per file. One renderable unit per file — no `private var someView: some View`. Every
user-facing string in the catalogue, never an inline literal and never a named `String` constant. No
comments. Sizes are declared flexible and divided by the container, never computed and handed back.
