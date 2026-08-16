import AppKit
import CoreGraphics
import Foundation

package struct CoreGraphicsWindowSource: CgWindowSourcePort {
    package init() {}

    package func currentWindows() -> [CgWindowRecord] {
        let options: CGWindowListOption = [.optionAll, .excludeDesktopElements]
        guard let entries = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            return []
        }
        let ranks = frontToBackRanks()

        return entries.compactMap { entry in
            guard let windowId = entry[kCGWindowNumber as String] as? CGWindowID else { return nil }

            return record(from: entry, zOrder: ranks[windowId] ?? Int.max)
        }
    }

    private func frontToBackRanks() -> [CGWindowID: Int] {
        let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
        guard let entries = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]]
        else {
            return [:]
        }
        let ids = entries.compactMap { $0[kCGWindowNumber as String] as? CGWindowID }

        return Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($0.element, $0.offset) })
    }

    private func record(from entry: [String: Any], zOrder: Int) -> CgWindowRecord? {
        guard let windowId = entry[kCGWindowNumber as String] as? CGWindowID,
              let ownerPid = entry[kCGWindowOwnerPID as String] as? pid_t,
              let boundsDictionary = entry[kCGWindowBounds as String] as? [String: Any],
              let bounds = CGRect(dictionaryRepresentation: boundsDictionary as CFDictionary)
        else {
            return nil
        }
        return CgWindowRecord(
            windowId: windowId,
            ownerPid: ownerPid,
            ownerName: entry[kCGWindowOwnerName as String] as? String,
            title: entry[kCGWindowName as String] as? String,
            bounds: MainActor.assumeIsolated { ScreenCoordinateConverter.toCocoa(bounds) },
            layer: entry[kCGWindowLayer as String] as? Int ?? WindowMatchingMetrics.normalWindowLayer,
            isOnScreen: entry[kCGWindowIsOnscreen as String] as? Bool ?? true,
            zOrder: zOrder
        )
    }
}
