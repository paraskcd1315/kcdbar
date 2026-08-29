import AppKit
import CoreGraphics
import Foundation
import Testing

@testable import KcdBarTaskbar

struct LiveSpaceHarness {
    @Test func watchTheRealMachine() async throws {
        let seconds = Double(ProcessInfo.processInfo.environment["KCDBAR_LIVE_SECONDS"] ?? "0") ?? 0
        guard seconds > 0 else { return }

        let bundle = ProcessInfo.processInfo.environment["KCDBAR_LIVE_BUNDLE"] ?? "com.google.Chrome"
        guard let application = NSRunningApplication
            .runningApplications(withBundleIdentifier: bundle).first
        else {
            print("LIVE: \(bundle) is not running")
            return
        }
        let pid = application.processIdentifier
        let coreGraphicsSource = CoreGraphicsWindowSource()
        let accessibilitySource = AccessibilityWindowSource()
        let clock = DateFormatter()
        clock.dateFormat = "HH:mm:ss.SSS"

        var previous: [ManagedWindow] = []
        var last = ""
        let deadline = Date().addingTimeInterval(seconds)
        while Date() < deadline {
            let coreGraphics = coreGraphicsSource.currentWindows(flipReference: 0)
            let scan = accessibilitySource.windows(forPids: [pid])
            let windows = WindowReconciler.reconcile(
                coreGraphics: coreGraphics,
                accessibility: scan,
                previous: previous
            )
            previous = windows
            let mine = windows.filter { $0.ownerPid == pid }
            let entries = WindowPresentationPolicy.taskbarEntries(from: mine)
            let reading = """
                ax=\(scan.records.filter { $0.ownerPid == pid }.count) \
                liveOmitted=\(scan.liveOmittedIds.sorted()) \
                windows=\(mine.compactMap(\.identity.cgWindowId).sorted()) \
                entries=\(entries.compactMap(\.identity.cgWindowId).sorted())
                """
            if reading != last {
                print("LIVE \(clock.string(from: Date())) \(reading)")
                last = reading
            }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
    }
}
