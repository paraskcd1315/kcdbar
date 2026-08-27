import CoreGraphics

package protocol CgWindowSourcePort: Sendable {
    func currentWindows(flipReference: CGFloat) -> [CgWindowRecord]
}
