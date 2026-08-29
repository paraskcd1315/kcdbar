import CoreGraphics
import Foundation
import Observation

@MainActor
@Observable
package final class WindowRegistry {
    package private(set) var windows: [ManagedWindow] = []
    package private(set) var displays: [DisplayGeometry] = []
    package private(set) var frontmostPid: pid_t?
    package private(set) var hasAccessibility = false
    package private(set) var bundleIdentifiers: [pid_t: String] = [:]
    package private(set) var applications: [RunningApplication] = []
    package private(set) var lastRefreshDuration: TimeInterval = 0
    package private(set) var lastScanCounts: WindowScanCounts = .empty

    package var taskbarEntries: [ManagedWindow] {
        WindowPresentationPolicy.taskbarEntries(from: windows)
    }

    package func window(withEntryId entryId: String) -> ManagedWindow? {
        windows.first { WindowEntryIdentifier.text(for: $0.identity) == entryId }
    }

    private let coreGraphicsSource: CgWindowSourcePort
    private let accessibilitySource: AxWindowSourcePort
    private let applicationsSource: RunningApplicationsPort
    private let displaySource: any DisplayGeometryPort
    private let authorization: any AccessibilityAuthorizationPort

    package init(
        coreGraphicsSource: CgWindowSourcePort,
        accessibilitySource: AxWindowSourcePort,
        applicationsSource: RunningApplicationsPort,
        displaySource: any DisplayGeometryPort,
        authorization: any AccessibilityAuthorizationPort
    ) {
        self.coreGraphicsSource = coreGraphicsSource
        self.accessibilitySource = accessibilitySource
        self.applicationsSource = applicationsSource
        self.displaySource = displaySource
        self.authorization = authorization
    }

    private var generation = 0

    nonisolated package static func pidsWorthAsking(
        in coreGraphics: [CgWindowRecord], previousOwners: Set<pid_t>
    ) -> [pid_t] {
        let owners = Set(coreGraphics.filter(WindowReconciler.isManageable).map(\.ownerPid))

        return Array(owners.union(previousOwners))
    }

    nonisolated private static func read(
        coreGraphics source: any CgWindowSourcePort,
        accessibility axSource: any AxWindowSourcePort,
        flipReference: CGFloat,
        previousOwners: Set<pid_t>
    ) async -> WindowRead {
        await Task.detached(priority: .userInitiated) {
            let coreGraphics = source.currentWindows(flipReference: flipReference)
            let pids = pidsWorthAsking(in: coreGraphics, previousOwners: previousOwners)

            return WindowRead(coreGraphics: coreGraphics, accessibility: axSource.windows(forPids: pids))
        }.value
    }

    package func refresh() async {
        let started = Date()
        generation += 1
        let mine = generation
        hasAccessibility = authorization.isTrusted
        displays = displaySource.currentDisplays()
        frontmostPid = applicationsSource.frontmostPid
        let applications = applicationsSource.currentApplications()
            .filter { $0.pid != ProcessInfo.processInfo.processIdentifier }
        let byPid = Dictionary(uniqueKeysWithValues: applications.map { ($0.pid, $0) })
        self.applications = applications
        bundleIdentifiers = byPid.compactMapValues(\.bundleIdentifier)

        let read = await Self.read(
            coreGraphics: coreGraphicsSource,
            accessibility: accessibilitySource,
            flipReference: DisplayFlipReference.of(displays),
            previousOwners: Set(windows.map(\.ownerPid))
        )
        guard mine == generation else { return }

        let coreGraphics = read.coreGraphics
        let accessibility = read.accessibility

        lastScanCounts = WindowScanCounts(
            applications: applications.count,
            coreGraphicsRecords: coreGraphics.count,
            manageableCoreGraphicsRecords: coreGraphics.filter(WindowReconciler.isManageable).count,
            accessibilityRecords: accessibility.records.count
        )

        windows = WindowReconciler
            .reconcile(coreGraphics: coreGraphics, accessibility: accessibility, previous: windows)
            .map { window in
                guard window.ownerName == nil, let name = byPid[window.ownerPid]?.localizedName else {
                    return window
                }
                return ManagedWindow(
                    identity: window.identity,
                    ownerPid: window.ownerPid,
                    ownerName: name,
                    title: window.title,
                    bounds: window.bounds,
                    isMinimized: window.isMinimized,
                    isFullScreen: window.isFullScreen,
                    isOnScreen: window.isOnScreen,
                    zOrder: window.zOrder,
                    source: window.source,
                    accessibilityTitle: window.accessibilityTitle
                )
            }
        lastRefreshDuration = Date().timeIntervalSince(started)
    }
}
