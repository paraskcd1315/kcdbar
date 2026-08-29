import AppKit
import ApplicationServices

@_silgen_name("_AXUIElementGetWindow")
private func AXUIElementGetWindowIdentifier(_ element: AXUIElement, _ identifier: UnsafeMutablePointer<CGWindowID>) -> AXError

let arguments = Array(CommandLine.arguments.dropFirst())
let bundle = arguments.first ?? "com.googlecode.iterm2"
let mode = arguments.dropFirst().first ?? "list"

guard AXIsProcessTrusted() else {
    print("this process is not trusted for Accessibility")
    exit(1)
}
guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundle).first else {
    print("\(bundle) is not running")
    exit(1)
}
let root = AXUIElementCreateApplication(app.processIdentifier)

func windowId(of element: AXUIElement) -> CGWindowID {
    var identifier: CGWindowID = 0
    return AXUIElementGetWindowIdentifier(element, &identifier) == .success ? identifier : 0
}

func attribute(_ element: AXUIElement, _ name: String) -> CFTypeRef? {
    var value: CFTypeRef?
    return AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success ? value : nil
}

func describe(_ label: String, _ elements: [AXUIElement]) {
    let rows = elements.map { element -> String in
        let title = attribute(element, kAXTitleAttribute) as? String ?? "?"
        let role = attribute(element, kAXRoleAttribute) as? String ?? "?"
        return "\(windowId(of: element)):\(role):\(title)"
    }
    print("\(label) count=\(elements.count) \(rows)")
}

func onScreen(_ id: CGWindowID) -> Bool {
    let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
    return list.contains { ($0[kCGWindowNumber as String] as? CGWindowID) == id }
}

func listedWindows() -> [AXUIElement] {
    attribute(root, kAXWindowsAttribute) as? [AXUIElement] ?? []
}

switch mode {
case "list":
    describe("AXWindows", listedWindows())
    describe("AXChildren", (attribute(root, kAXChildrenAttribute) as? [AXUIElement] ?? []).filter {
        attribute($0, kAXRoleAttribute) as? String == kAXWindowRole
    })
    var values: CFArray?
    let status = AXUIElementCopyAttributeValues(root, kAXWindowsAttribute as CFString, 0, 100, &values)
    describe("AXWindows(values \(status.rawValue))", values as? [AXUIElement] ?? [])
    let enhanced = AXUIElementSetAttributeValue(root, "AXEnhancedUserInterface" as CFString, kCFBooleanTrue)
    describe("AXWindows(enhanced \(enhanced.rawValue))", listedWindows())
    AXUIElementSetAttributeValue(root, "AXEnhancedUserInterface" as CFString, kCFBooleanFalse)
    describe("AXFocusedWindow", [attribute(root, kAXFocusedWindowAttribute)].compactMap { $0 }.map { $0 as! AXUIElement })
case "hold":
    guard let wanted = arguments.dropFirst(2).first.flatMap({ CGWindowID($0) }) else {
        print("usage: hold <windowId> [seconds]")
        exit(1)
    }
    let seconds = arguments.dropFirst(3).first.flatMap { Double($0) } ?? 10
    guard let element = listedWindows().first(where: { windowId(of: $0) == wanted }) else {
        print("window \(wanted) is not listed now")
        exit(1)
    }
    print("held \(wanted) onScreen=\(onScreen(wanted)); switch Space within \(seconds)s")
    Thread.sleep(forTimeInterval: seconds)
    print("before raise: onScreen=\(onScreen(wanted)) listed=\(listedWindows().map { windowId(of: $0) })")
    let activated = app.activate()
    let raised = AXUIElementPerformAction(element, kAXRaiseAction as CFString)
    let main = AXUIElementSetAttributeValue(element, kAXMainAttribute as CFString, kCFBooleanTrue)
    Thread.sleep(forTimeInterval: 1.5)
    print("activate=\(activated) raise=\(raised.rawValue) main=\(main.rawValue) onScreen=\(onScreen(wanted)) listed=\(listedWindows().map { windowId(of: $0) })")
default:
    print("usage: diagnose-space-raise.swift <bundle> list | hold <windowId> [seconds]")
}
