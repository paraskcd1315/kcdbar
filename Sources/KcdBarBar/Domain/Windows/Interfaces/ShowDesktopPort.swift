@MainActor
package protocol ShowDesktopPort {
    var isAvailable: Bool { get }
    func toggle() -> Bool
}
