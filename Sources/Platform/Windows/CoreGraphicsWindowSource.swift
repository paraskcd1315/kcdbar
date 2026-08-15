import CoreGraphics
import Foundation

struct CoreGraphicsWindowSource: CgWindowSourceProviding {
    func currentWindows() -> [CgWindowRecord] {
        let options: CGWindowListOption = [.optionAll, .excludeDesktopElements]
        guard let entries = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            return []
        }
        return entries.enumerated().compactMap { index, entry in
            record(from: entry, zOrder: index)
        }
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
            bounds: bounds,
            layer: entry[kCGWindowLayer as String] as? Int ?? 0,
            isOnScreen: entry[kCGWindowIsOnscreen as String] as? Bool ?? true,
            zOrder: zOrder
        )
    }
}
