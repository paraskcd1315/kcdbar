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

    private func pidsWorthAsking(in coreGraphics: [CgWindowRecord]) -> [pid_t] {
        let owners = Set(coreGraphics.filter(WindowReconciler.isManageable).map(\.ownerPid))

        return Array(owners.union(windows.map(\.ownerPid)))
    }

    package func refresh() {
        let started = Date()
        hasAccessibility = authorization.isTrusted
        displays = displaySource.currentDisplays()
        frontmostPid = applicationsSource.frontmostPid
        let applications = applicationsSource.currentApplications()
        let byPid = Dictionary(uniqueKeysWithValues: applications.map { ($0.pid, $0) })
        bundleIdentifiers = byPid.compactMapValues(\.bundleIdentifier)
        let coreGraphics = coreGraphicsSource.currentWindows()
        let accessibility = accessibilitySource.windows(forPids: pidsWorthAsking(in: coreGraphics))

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
                    source: window.source
                )
            }
        lastRefreshDuration = Date().timeIntervalSince(started)
    }
}
