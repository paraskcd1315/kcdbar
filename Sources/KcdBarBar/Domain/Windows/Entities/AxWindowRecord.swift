import CoreGraphics

struct AxWindowRecord: Equatable, Sendable {
    let ownerPid: pid_t
    let cgWindowId: CGWindowID?
    let title: String?
    let role: String?
    let subrole: String?
    let bounds: CGRect?
    let isMinimized: Bool
    let isFullScreen: Bool
    let indexInApplication: Int
}
