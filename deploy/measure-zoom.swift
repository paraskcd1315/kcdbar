import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
app.finishLaunching()

guard let screen = NSScreen.screens.first(where: { $0.localizedName.contains("MSI") }) ?? NSScreen.main else {
    exit(1)
}

let window = NSWindow(
    contentRect: NSRect(x: screen.frame.minX + 200, y: screen.frame.minY + 200, width: 500, height: 300),
    styleMask: [.titled, .closable, .resizable, .miniaturizable],
    backing: .buffered,
    defer: false
)
window.setFrameOrigin(NSPoint(x: screen.frame.minX + 200, y: screen.frame.minY + 200))
window.orderFrontRegardless()
RunLoop.current.run(until: Date().addingTimeInterval(0.5))

print("screen        frame=\(screen.frame)")
print("screen      visible=\(screen.visibleFrame)")
print("before zoom  window=\(window.frame)")

window.zoom(nil)
RunLoop.current.run(until: Date().addingTimeInterval(0.8))

print("after  zoom  window=\(window.frame)")

let coversDockStrip = window.frame.minY <= screen.frame.minY + 1
print("zoomed window reaches the screen's bottom edge: \(coversDockStrip)")
