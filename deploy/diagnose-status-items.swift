import AppKit
import CoreGraphics

let statusLevel = Int(CGWindowLevelForKey(.statusWindow))
let options: CGWindowListOption = [.optionAll, .excludeDesktopElements]
let entries = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] ?? []

var statusOwners: [pid_t: (name: String, count: Int)] = [:]
var normalOwners: [pid_t: Int] = [:]

for entry in entries {
    guard let pid = entry[kCGWindowOwnerPID as String] as? pid_t else { continue }
    let layer = entry[kCGWindowLayer as String] as? Int ?? 0
    let name = entry[kCGWindowOwnerName as String] as? String ?? "?"
    if layer == statusLevel {
        statusOwners[pid, default: (name, 0)].count += 1
    } else if layer == 0 {
        normalOwners[pid, default: 0] += 1
    }
}

print("status-level windows (layer \(statusLevel)) by owner:")
for (pid, owner) in statusOwners.sorted(by: { $0.value.count > $1.value.count }) {
    let app = NSRunningApplication(processIdentifier: pid)
    let policy = app.map { "\($0.activationPolicy.rawValue)" } ?? "?"
    print("  pid=\(pid) \(owner.name) bundle=\(app?.bundleIdentifier ?? "?") policy=\(policy) items=\(owner.count) layer0=\(normalOwners[pid] ?? 0)")
}

print("\nregular applications with no layer-0 window:")
for app in NSWorkspace.shared.runningApplications where app.activationPolicy == .regular {
    let pid = app.processIdentifier
    guard (normalOwners[pid] ?? 0) == 0 else { continue }
    print("  pid=\(pid) \(app.localizedName ?? "?") bundle=\(app.bundleIdentifier ?? "?") status=\(statusOwners[pid]?.count ?? 0) launched=\(app.launchDate.map { "\($0)" } ?? "?")")
}
