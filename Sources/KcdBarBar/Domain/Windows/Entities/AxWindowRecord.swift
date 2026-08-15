import CoreGraphics

package struct AxWindowRecord: Equatable, Sendable {
    package let ownerPid: pid_t
    package let cgWindowId: CGWindowID?
    package let title: String?
    package let role: String?
    package let subrole: String?
    package let bounds: CGRect?
    package let isMinimized: Bool
    package let isFullScreen: Bool
    package let indexInApplication: Int
}
