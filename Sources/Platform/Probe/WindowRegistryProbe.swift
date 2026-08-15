import AppKit
import Foundation

@MainActor
enum WindowRegistryProbe {
    static func report(registry: WindowRegistry, authorization: AccessibilityAuthorizing) {
        guard authorization.isTrusted else {
            log("accessibility NOT granted — requesting; window state is unavailable until it is")
            authorization.requestTrust()
            return
        }

        registry.refresh()
        summarise(registry: registry, stage: "baseline")

        guard let ownWindow = NSApp.windows.first(where: { $0.isVisible && $0.title.isEmpty == false }) else {
            log("no own window to exercise the minimized path with")
            return
        }

        let source = AccessibilityWindowSource()
        let ownPid = ProcessInfo.processInfo.processIdentifier
        reportOwnWindows(source: source, pid: ownPid, stage: "own windows before miniaturize")

        ownWindow.miniaturize(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            reportOwnWindows(source: source, pid: ownPid, stage: "own windows after miniaturize")
            ownWindow.deminiaturize(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                reportOwnWindows(source: source, pid: ownPid, stage: "own windows after deminiaturize")
            }
        }
    }

    private static func reportOwnWindows(source: AccessibilityWindowSource, pid: pid_t, stage: String) {
        let records = source.windows(forPids: [pid])
        log("[\(stage)] axRecords=\(records.count) minimized=\(records.filter(\.isMinimized).count)")
        for record in records {
            log("  ax \"\(record.title ?? "<no title>")\" minimized=\(record.isMinimized) bridgedId=\(record.cgWindowId.map(String.init) ?? "none")")
        }
    }

    private static func summarise(registry: WindowRegistry, stage: String) {
        let entries = registry.taskbarEntries
        let all = registry.windows
        let counts = registry.lastScanCounts
        log("""
        [\(stage)] apps=\(counts.applications) cgRecords=\(counts.coreGraphicsRecords) \
        cgManageable=\(counts.manageableCoreGraphicsRecords) axRecords=\(counts.accessibilityRecords) \
        reconciled=\(all.count) taskbarEntries=\(entries.count) \
        minimized=\(entries.filter(\.isMinimized).count) \
        refresh=\(Int(registry.lastRefreshDuration * 1000))ms
        """)
        for window in entries {
            log("  [\(window.source.rawValue)] \(window.ownerName ?? "?") — \(window.title ?? "<no title>") minimized=\(window.isMinimized)")
        }
    }

    private static func log(_ message: String) {
        FileHandle.standardError.write(Data("KCDBAR-13 \(message)\n".utf8))
    }
}
