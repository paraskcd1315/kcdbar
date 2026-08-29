# KCDBar

A Windows-style, deeply customizable **taskbar and Start menu for macOS 26** that replaces the Dock.

The macOS Dock cannot minimize a window. On Windows a taskbar button is a toggle — click it while the
window is in front and it minimizes, click again and it returns focused. That single missing
interaction is what this exists for; everything else is so the Dock can be hidden for good.

Windows-style is the default, not the ceiling: a Dock-like preset is a first-class target, because the
customization is the product.

## Status

**Alpha — `0.0.1`.** A working taskbar with a window registry and drag reorder, a tray and Control
Centre (clock, battery, wifi, bluetooth, brightness, sound, trash), a Start menu with the application
catalogue and pinned categories, and a Settings window whose axes are all read — a shipped preset is
forked rather than edited.

The version is deliberately below `1.0` to say so out loud. Expect defects.

## Requirements

| | |
|---|---|
| macOS | 26.0 or later, Apple Silicon |
| Xcode | 26.x |
| XcodeGen | any recent release; the `XCODEGEN` env var overrides its path |

The app is **non-sandboxed** and **not notarized**, and it will not be distributed through the App
Store — hiding the Dock requires writing another application's preference domain, which the sandbox
forbids.

**Installing a release build.** Because it is signed with a self-signed certificate rather than a
Developer ID, Gatekeeper will refuse it on first launch. Right-click → Open no longer works — that was
removed in macOS 15. Go to **System Settings → Privacy & Security**, scroll to Security, and press
**Open Anyway**, within an hour of seeing the warning. KCDBar also needs **Accessibility** to manage
other applications' windows.

## Building

```sh
./deploy/create-signing-identity.sh   # once per machine, needs a password prompt
./deploy/build.sh                     # generate, build, verify the signature
./deploy/install.sh                   # build, then install to /Applications
./deploy/release.sh                   # build, then cut a signed dmg into dist/
```

`KCDBar.xcodeproj` is generated from `project.yml` and is gitignored — **never hand-author it**.

### Versioning

`VERSION` at the repo root is the only place the version lives, and it reads
**`milestone.feature.fix`**:

| Part | Bumped when | Resets |
|---|---|---|
| **milestone** | a milestone lands — the epics in `Backlog.md` | feature and fix to 0 |
| **feature** | a major feature ships within that milestone | fix to 0 |
| **fix** | bugs are fixed, in that feature or an earlier one | — |

A `0` milestone means none has landed yet, which is why `0.0.1` is an alpha and the About window says
so — `AppVersion.isPrerelease` reads the first number, nothing else.

`build.sh` refuses a version that is not three integers, then takes the build number from
`git rev-list --count HEAD` and the short hash from the tree, so **every binary names the commit it
came from**. `release.sh` binds the two the other way as well: an annotated `v<version>` tag and a row
in [`RELEASES.md`](RELEASES.md), and it refuses to reuse a tag that already points somewhere else.

## 🔴 KcdSignal — a private dependency you have to remove first

`Package.swift` depends on **KcdSignal** by path (`../kcdsignal`). It is private and **will not be
published**, so `swift build` on a fresh clone fails at dependency resolution. Take it out before
anything else.

It drives one feature and one only: the timer readout and tracker totals beside the clock, which read
a snapshot written by the author's own tooling. Nothing else in the app touches it, and the widget
already hides itself when the port reports unavailable (`TaskbarItems.swift`) — so a build without
KcdSignal is a complete taskbar minus that one readout.

**1.** In `Package.swift`, delete the `.package(path: "../kcdsignal")` entry and the
`.product(name: "KcdSignal", package: "KcdSignal")` line from `KcdBarTray`'s dependencies.

**2.** Delete the files that import it:

```
Sources/KcdBarTray/Infrastructure/Timer/KcdSignalAvailability.swift
Sources/KcdBarTray/Infrastructure/Timer/KcdSignalTimerSource.swift
Sources/KcdBarTray/Infrastructure/Timer/SignalProblems.swift
Sources/KcdBarTray/Infrastructure/Timer/ConsoleTicketOpener.swift
Sources/KcdBarTray/Infrastructure/Totals/KcdSignalTotalsSource.swift
Sources/KcdBarTray/Infrastructure/Totals/TotalsChannels.swift
Tests/KcdBarTrayTests/TimerSignalPayloadTests.swift
Tests/KcdBarTrayTests/TrackerPaceTests.swift
Tests/KcdBarTrayTests/RunningTimerOpenTests.swift
```

`Domain/Timer/Entities/ConsoleServer.swift` and `Domain/Timer/Utils/ConsoleServerMetrics.swift` are
orphaned too. They still compile, so deleting them is optional.

**3.** Drop the default argument from `TimerMonitor.init` — `availability: any SignalAvailabilityPort
= KcdSignalAvailability()` becomes a plain parameter.

**4.** Supply stubs where `AppServices` builds the monitors. The ports are already declared in
`KcdBarTray/Domain/Timer/Interfaces` and `…/Totals/Interfaces`, so each is a few lines:

```swift
@MainActor
struct NoTimerSignal: TimerSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {}
    func stop() {}
}

@MainActor
struct NoTotalsSignal: TotalsSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {}
    func stop() {}
}

struct NoSignalAvailability: SignalAvailabilityPort { var isPresent: Bool { false } }

struct NoTicketOpener: TicketOpenerPort {
    var isAvailable: Bool { false }
    func open(contextPath: String, key: String) async -> Bool { false }
}
```

`TimerSignalPort` and `TotalsSignalPort` are both `@MainActor`, so the stubs need the attribute or the
conformance will not compile.

### Why the signing step is not optional

macOS ties the Accessibility grant to the signature's designated requirement. **Ad-hoc signing has no
stable designated requirement, so every rebuild looks like a new app and the grant is lost.** The
self-signed `KCDBar Local` certificate keeps that identity constant across builds. `codesign -d -r-`
should show the designated requirement pinned to the certificate hash.

`ENABLE_HARDENED_RUNTIME` stays `NO`: with a self-signed certificate, library validation would demand
a Team ID the signature has not got, and the app would not launch.

## Layout

Five SwiftPM modules, so a layering violation is a compile error rather than something review has to
catch:

```
Package.swift                  the five targets and the graph between them
project.yml                    XcodeGen; the app target is a shim + Resources + Info.plist
Xcode/App/main.swift           three lines — KcdBarLauncher.run()
Sources/
  KcdBarDesignSystem/          SwiftUI only, no domain types
  KcdBarTray/                  clock · battery · wifi · bluetooth · brightness · sound · trash
  KcdBarTaskbar/               windows · presets · panel hosting · Start menu · settings
  KcdBarPreferences/           the SwiftData store, an adapter for Taskbar's ports
  KcdBarMain/                  composition root
Resources/
  Localizable.xcstrings        every user-facing string
  KCDBar.icon                  Icon Composer package, two layer groups
deploy/                        build, sign, install, release
VERSION                        the marketing version, and nothing else
```

Dependencies point one way: **DesignSystem ← Tray ← Taskbar ← Preferences**, with Main above all four.
Each context module carries `Domain/ Data/ Infrastructure/ Presentation/` inside it, and **only
`Infrastructure` may import an OS framework** — that is what lets the test suite run without launching
the app. Access is `package`, never `public`, which is why the app target is a three-line shim.

## Conventions

One type per file. One renderable unit per file — no `private var someView: some View`. Every
user-facing string in the catalogue, never an inline literal and never a named `String` constant. No
comments. Sizes are declared flexible and divided by the container, never computed and handed back.
Every code file — Swift, shell, Python — opens with the Apache License header and the line
`Copyright 2026 Paras Mohandas Khanchandani Chandani` (after the shebang in a script); a file without
it is not finished.

## License

Copyright 2026 Paras Mohandas Khanchandani Chandani. Licensed under the Apache License, Version 2.0 —
see [LICENSE](LICENSE). This repository takes no contributions; fork it. A modified copy must say so in
the files it changes (License §4b), and the KCDBar name is not granted (§6).
