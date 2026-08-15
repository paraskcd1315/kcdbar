import Foundation
import Observation

@MainActor
@Observable
final class WindowRegistry {
    private(set) var windows: [ManagedWindow] = []
    private(set) var lastRefreshDuration: TimeInterval = 0
    private(set) var lastScanCounts: WindowScanCounts = .empty

    var taskbarEntries: [ManagedWindow] {
        WindowPresentationPolicy.taskbarEntries(from: windows)
    }

    private let coreGraphicsSource: CgWindowSourceProviding
    private let accessibilitySource: AxWindowSourceProviding
    private let applicationsSource: RunningApplicationsProviding

    init(
        coreGraphicsSource: CgWindowSourceProviding,
        accessibilitySource: AxWindowSourceProviding,
        applicationsSource: RunningApplicationsProviding
    ) {
        self.coreGraphicsSource = coreGraphicsSource
        self.accessibilitySource = accessibilitySource
        self.applicationsSource = applicationsSource
    }

    func refresh() {
        let started = Date()
        let applications = applicationsSource.currentApplications()
        let byPid = Dictionary(uniqueKeysWithValues: applications.map { ($0.pid, $0) })
        let coreGraphics = coreGraphicsSource.currentWindows()
        let accessibility = accessibilitySource.windows(forPids: applications.map(\.pid))

        lastScanCounts = WindowScanCounts(
            applications: applications.count,
            coreGraphicsRecords: coreGraphics.count,
            manageableCoreGraphicsRecords: coreGraphics.filter(WindowReconciler.isManageable).count,
            accessibilityRecords: accessibility.count
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
                    isOnScreen: window.isOnScreen,
                    zOrder: window.zOrder,
                    source: window.source
                )
            }
        lastRefreshDuration = Date().timeIntervalSince(started)
    }
}
