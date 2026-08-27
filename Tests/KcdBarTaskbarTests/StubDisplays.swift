import CoreGraphics
@testable import KcdBarTaskbar

@MainActor
struct StubDisplays: DisplayGeometryPort {
    func currentDisplays() -> [DisplayGeometry] {
        [DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isPrimary: true)]
    }
}
