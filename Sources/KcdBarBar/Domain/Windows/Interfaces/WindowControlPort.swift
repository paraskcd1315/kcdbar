import CoreGraphics

@MainActor
package protocol WindowControlPort {
    func perform(_ action: WindowToggleAction, on window: ManagedWindow) -> Bool
    func close(_ window: ManagedWindow) -> Bool
    func setFrame(_ frame: CGRect, on window: ManagedWindow) -> Bool
}
