# KCDBar

A Windows-style, deeply customizable **taskbar and Start menu for macOS 26** that replaces the Dock.

The macOS Dock cannot minimize a window. On Windows a taskbar button is a toggle — click it while the
window is in front and it minimizes, click again and it returns focused. That single missing
interaction is what this exists for; everything else is so the Dock can be hidden for good.

Windows-style is the default, not the ceiling: a Dock-like preset is a first-class target, because the
customization is the product.

## Status

**Alpha — `0.6.8`.** Every `0.x` is an alpha: no milestone has been declared finished, and the About
window says so. It is the author's daily driver, and defects arrive from real use. Every version and
the commit it was cut from are in [`RELEASES.md`](RELEASES.md).

## What it does

**The taskbar**

- One button per window, or one per application in the presets that group. A click on the frontmost
  window minimizes it; a second click restores it. A click on a group minimizes or restores every
  window in it, and **Command**-click walks them one at a time. A middle click opens a new window.
- Pinned launchers, drag to reorder, a context menu to pin, close or quit, and a badge on an entry
  that has a fullscreen window.
- **Hover previews**: a live thumbnail of every window of the application, on every display and every
  Space. A click on a tile raises its window and switches Space when it has to; the ✕ closes it.
- **Aero Peek**: rest on a preview tile and the screen shows that window alone over the desktop; rest
  on Show Desktop and it shows the desktop. Every other window becomes a glass outline. Move away and
  nothing has moved. Desktop Spaces only — never over a fullscreen app.
- **Show Desktop** at the bar's end, through the system's own Show Desktop.
- The bar hides for a fullscreen window and comes back at the screen edge. Windows that would sit
  under it are fitted above it, and below the menu bar on a notched display. An application can quit
  when its last window closes, with exclusions for the ones that live in the menu bar.

**The Start menu**

- Every installed application, **A–Z** or by **category**, as a list or a grid, with a letter index and
  recent apps. Categories open like iOS folders, over a blurred Start menu.
- A pinned pane with named, collapsible groups.
- Spotlight search, and lock, sleep, restart, shut down and log out — macOS shows its own confirmation.

**The tray and Control Centre**: clock (a click opens Notification Center), battery, Wi-Fi, Bluetooth,
brightness, sound and trash.

**Settings**: five shipped presets — KCD, Windows 11, Windows 10, Dock, Minimal — that you fork rather
than edit. Every axis is data: edge, alignment, grouping, what an entry shows (icon, title or both),
the material (Liquid Glass, vibrancy or solid), auto-hide, what to do with the Dock, and launch at
login.

## Requirements

| | |
|---|---|
| macOS | 26.0 or later, Apple Silicon |
| Xcode | 27 (Swift 6.2 language mode 6) |
| XcodeGen | any recent release; the `XCODEGEN` env var overrides its path |

The app is **non-sandboxed** and **not notarized**, and it will not be distributed through the App
Store — hiding the Dock requires writing another application's preference domain, which the sandbox
forbids.

**Permissions.** **Accessibility** to manage other applications' windows. **Screen Recording** for the
hover thumbnails and Aero Peek — without it a tile shows the application's icon. **Automation**, to
send `loginwindow` the power actions.

**Installing a release build.** Because it is signed with a self-signed certificate rather than a
Developer ID, Gatekeeper will refuse it on first launch. Right-click → Open no longer works — that was
removed in macOS 15. Go to **System Settings → Privacy & Security**, scroll to Security, and press
**Open Anyway**, within an hour of seeing the warning.

## Building

```sh
./deploy/create-signing-identity.sh   # once per machine, needs a password prompt
./deploy/build.sh                     # generate, build, verify the signature
./deploy/install.sh                   # build, then install to /Applications
./deploy/release.sh                   # build, tag, record the ledger row, cut a signed dmg into dist/
swift test                            # the suites run without launching the app
```

`KCDBar.xcodeproj` is generated from `project.yml` and is gitignored — **never hand-author it**.

### Versioning

`VERSION` at the repo root is the only place the version lives, and it reads
**`milestone.feature.fix`**:

| Part | Bumped when | Resets |
|---|---|---|
| **milestone** | a milestone lands — M1 the founding interaction … M5 polish | feature and fix to 0 — `x.0.0` |
| **feature** | a feature ships whole within the current milestone | fix to 1 — `x.y.1` |
| **fix** | bug fixes, corrections, UI polish, a rework of what shipped | — |

The fix digit is `0` only when the milestone changes, and it is the default bump. `build.sh` refuses a
version that is not three integers, or `x.y.0` with `y` above zero. It takes the build number from
`git rev-list --count HEAD` and the short hash from the tree, so **every binary names the commit it
came from**. `release.sh` binds the two the other way as well: an annotated `v<version>` tag and a row
in [`RELEASES.md`](RELEASES.md), and it refuses a dirty tree or a tag that already points somewhere
else.

## 🔴 KcdSignal — a private dependency you have to remove first

`Package.swift` depends on **KcdSignal** by path (`../kcdsignal`). It is private and **will not be
published**, so `swift build` on a fresh clone fails at dependency resolution. Take it out before
anything else.

It feeds four readouts beside the clock, all from the author's own tooling: the running timer, the
tracker totals, the day panel and the live sessions. Each one already hides itself when its channel
is absent, so a build without KcdSignal is a complete taskbar minus those four.

**1.** In `Package.swift`, delete the `.package(path: "../kcdsignal")` entry and the
`.product(name: "KcdSignal", package: "KcdSignal")` line from `KcdBarTray`'s dependencies.

**2.** Delete the files that import it:

```
Sources/KcdBarTray/Infrastructure/Timer/KcdSignalAvailability.swift
Sources/KcdBarTray/Infrastructure/Timer/KcdSignalTimerSource.swift
Sources/KcdBarTray/Infrastructure/Timer/SignalProblems.swift
Sources/KcdBarTray/Infrastructure/Totals/KcdSignalTotalsSource.swift
Sources/KcdBarTray/Infrastructure/Totals/TotalsChannels.swift
Sources/KcdBarTray/Infrastructure/Day/KcdSignalDaySource.swift
Sources/KcdBarTray/Infrastructure/Day/DayChannels.swift
Sources/KcdBarTray/Infrastructure/Sessions/KcdSignalSessionsSource.swift
Sources/KcdBarTray/Infrastructure/Sessions/SessionsChannels.swift
Tests/KcdBarTrayTests/TimerSignalPayloadTests.swift
Tests/KcdBarTrayTests/TrackerPaceTests.swift
Tests/KcdBarTrayTests/RunningTimerOpenTests.swift
Tests/KcdBarTrayTests/DaySignalTests.swift
Tests/KcdBarTrayTests/SessionsSignalTests.swift
```

**3.** Drop the default argument from `TimerMonitor.init` — `availability: any SignalAvailabilityPort
= KcdSignalAvailability()` becomes a plain parameter.

**4.** Supply stubs where `AppServices` builds the four monitors. The ports are already declared in
`KcdBarTray/Domain/{Timer,Totals,Day,Sessions}/Interfaces`, so each is a few lines. All four signal
ports are `@MainActor`, so the stubs need the attribute or the conformance will not compile:

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

@MainActor
struct NoDaySignal: DaySignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {}
    func stop() {}
}

@MainActor
struct NoSessionsSignal: SessionsSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable ([ClaudeSession]) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {}
    func stop() {}
}

struct NoSignalAvailability: SignalAvailabilityPort { var isPresent: Bool { false } }
```

The console helpers beside them (`ConsoleTicketOpener`, `ConsolePopoverOpener`, `ConsoleIconReader`,
`TmuxPaneFocus`) do not import KcdSignal and need nothing; with no console running they report
unavailable.

### Why the signing step is not optional

macOS ties the Accessibility and Screen Recording grants to the signature's designated requirement.
**Ad-hoc signing has no stable designated requirement, so every rebuild looks like a new app and the
grants are lost.** The self-signed `KCDBar Local` certificate keeps that identity constant across
builds. `codesign -d -r-` should show the designated requirement pinned to the certificate hash.

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
  KcdBarTray/                  clock · battery · wifi · bluetooth · brightness · sound · trash ·
                               timer · totals · day · sessions
  KcdBarTaskbar/               windows · previews · peek · presets · panel hosting · Start menu ·
                               settings · about
  KcdBarPreferences/           the SwiftData store, an adapter for Taskbar's ports
  KcdBarMain/                  composition root
Resources/
  Localizable.xcstrings        every user-facing string
  KCDBar.icon                  Icon Composer package, two layer groups
deploy/                        build, sign, install, release, and the diagnose-*.swift probes
VERSION                        the marketing version, and nothing else
RELEASES.md                    every version and the commit it was cut from
```

Dependencies point one way: **DesignSystem ← Tray ← Taskbar ← Preferences**, with Main above all four.
Each context module carries `Domain/ Data/ Infrastructure/ Presentation/` inside it, and **only
`Infrastructure` may import an OS framework** — that is what lets the test suite run without launching
the app. Access is `package`, never `public`, which is why the app target is a three-line shim. The
private macOS calls (SkyLight, CoreDock, the remote Accessibility token) are reached by `dlsym` and
degrade to nothing when a symbol is missing.

## Conventions

One type per file. One renderable unit per file — no `private var someView: some View`. Every
user-facing string in the catalogue, never an inline literal and never a named `String` constant. No
comments. Sizes are declared flexible and divided by the container, never computed and handed back.
A scroll area runs edge to edge and down to its container's bottom edge, under a frosted header whose
hairline shows only while content is scrolled under it. Every code file — Swift, shell, Python — opens
with the Apache License header and the line `Copyright 2026 Paras Mohandas Khanchandani Chandani`
(after the shebang in a script); a file without it is not finished.

## License

Copyright 2026 Paras Mohandas Khanchandani Chandani. Licensed under the Apache License, Version 2.0 —
see [LICENSE](LICENSE). This repository takes no contributions; fork it. A modified copy must say so in
the files it changes (License §4b), and the KCDBar name is not granted (§6).
