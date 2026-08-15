import AppKit

@MainActor
struct ScreenGeometrySource: DisplayGeometryPort {
    func currentDisplays() -> [DisplayGeometry] {
        NSScreen.screens.enumerated().map { index, screen in
            DisplayGeometry(
                id: screen.displayNumber ?? index,
                frame: screen.frame,
                isPrimary: index == 0
            )
        }
    }
}
