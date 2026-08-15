import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
app.finishLaunching()
RunLoop.current.run(until: Date().addingTimeInterval(0.6))

let screens = NSScreen.screens
for (index, screen) in screens.enumerated() {
    let frame = screen.frame
    let visible = screen.visibleFrame
    let bottomInset = visible.minY - frame.minY
    let topInset = frame.maxY - visible.maxY
    let leftInset = visible.minX - frame.minX
    let rightInset = frame.maxX - visible.maxX
    let name = screen.localizedName
    print("screen \(index) \"\(name)\" scale=\(screen.backingScaleFactor)")
    print("  frame=\(Int(frame.width))x\(Int(frame.height)) at (\(Int(frame.minX)),\(Int(frame.minY)))")
    print("  visible=\(Int(visible.width))x\(Int(visible.height)) at (\(Int(visible.minX)),\(Int(visible.minY)))")
    print("  insets bottom=\(bottomInset) top=\(topInset) left=\(leftInset) right=\(rightInset)")
}
