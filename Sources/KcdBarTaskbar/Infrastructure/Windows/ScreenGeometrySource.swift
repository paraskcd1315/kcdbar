import AppKit

@MainActor
package struct ScreenGeometrySource: DisplayGeometryPort {
    package init() {}

    package func currentDisplays() -> [DisplayGeometry] {
        NSScreen.screens.enumerated().map { index, screen in
            DisplayGeometry(
                id: screen.displayNumber ?? index,
                frame: screen.frame,
                isPrimary: index == 0
            )
        }
    }
}
