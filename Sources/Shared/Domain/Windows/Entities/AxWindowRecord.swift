import CoreGraphics

struct AxWindowRecord: Equatable, Sendable {
    let ownerPid: pid_t
    let cgWindowId: CGWindowID?
    let title: String?
    let bounds: CGRect?
    let isMinimized: Bool
    let indexInApplication: Int
}
