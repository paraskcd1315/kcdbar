import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let screens = NSScreen.screens
let flipReference = screens.first?.frame.maxY ?? 0

print("flipReference=\(flipReference)")
for (index, screen) in screens.enumerated() {
    let number = (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.intValue ?? index
    print("display \(number) \"\(screen.localizedName)\" frame=\(screen.frame)")
}

let regular = NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular }
print("\nregular apps: \(regular.compactMap(\.localizedName).joined(separator: ", "))")

guard let entries = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] else {
    exit(1)
}

print("\nlayer-0 windows at least 40x40:")
for entry in entries {
    guard let pid = entry[kCGWindowOwnerPID as String] as? pid_t,
          let layer = entry[kCGWindowLayer as String] as? Int, layer == 0,
          let boundsDictionary = entry[kCGWindowBounds as String] as? [String: Any],
          let cgBounds = CGRect(dictionaryRepresentation: boundsDictionary as CFDictionary),
          cgBounds.width >= 40, cgBounds.height >= 40
    else {
        continue
    }
    let owner = entry[kCGWindowOwnerName as String] as? String ?? "?"
    let title = entry[kCGWindowName as String] as? String ?? ""
    let cocoa = CGRect(
        x: cgBounds.origin.x,
        y: flipReference - cgBounds.origin.y - cgBounds.height,
        width: cgBounds.width,
        height: cgBounds.height
    )
    let assigned = screens.enumerated().map { index, screen -> (Int, CGFloat) in
        let number = (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.intValue ?? index
        let overlap = screen.frame.intersection(cocoa)
        return (number, overlap.isNull ? 0 : overlap.width * overlap.height)
    }
    let best = assigned.max { $0.1 < $1.1 }
    print("  \(owner) | \"\(title)\" cg=\(cgBounds) cocoa=\(cocoa) -> display \(best?.0 ?? -1) overlap=\(Int(best?.1 ?? 0))")
}
