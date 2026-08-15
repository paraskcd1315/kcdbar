import ApplicationServices
import CoreGraphics

@_silgen_name("_AXUIElementGetWindow")
private func AXUIElementGetWindowIdentifier(_ element: AXUIElement, _ identifier: UnsafeMutablePointer<CGWindowID>) -> AXError

enum AxWindowIdBridge {
    static func windowId(of element: AXUIElement) -> CGWindowID? {
        var identifier: CGWindowID = 0
        let status = AXUIElementGetWindowIdentifier(element, &identifier)
        guard status == .success, identifier != 0 else { return nil }
        return identifier
    }
}
