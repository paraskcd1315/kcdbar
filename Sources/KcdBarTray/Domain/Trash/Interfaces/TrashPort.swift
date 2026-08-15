import SwiftUI

@MainActor
package protocol TrashPort {
    func state() -> TrashState
    func icon(isEmpty: Bool) -> Image?
    func open()
    func empty()
    func watch(_ onChange: @escaping () -> Void)
    func stopWatching()
}
