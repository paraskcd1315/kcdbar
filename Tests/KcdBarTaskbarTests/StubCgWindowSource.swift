import CoreGraphics
@testable import KcdBarTaskbar

struct StubCgWindowSource: CgWindowSourcePort {
    let records: [CgWindowRecord]

    func currentWindows(flipReference: CGFloat) -> [CgWindowRecord] {
        records
    }
}
