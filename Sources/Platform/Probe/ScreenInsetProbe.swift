import AppKit

@MainActor
enum ScreenInsetProbe {
    static func report() {
        for (index, screen) in NSScreen.screens.enumerated() {
            let frame = screen.frame
            let visible = screen.visibleFrame
            let bottom = visible.minY - frame.minY
            let top = frame.maxY - visible.maxY
            FileHandle.standardError.write(Data("""
            KCDBAR-21 screen \(index) "\(screen.localizedName)" \
            frame=\(Int(frame.width))x\(Int(frame.height))@(\(Int(frame.minX)),\(Int(frame.minY))) \
            visible=\(Int(visible.width))x\(Int(visible.height))@(\(Int(visible.minX)),\(Int(visible.minY))) \
            bottomInset=\(bottom) topInset=\(top)

            """.utf8))
        }
    }
}
