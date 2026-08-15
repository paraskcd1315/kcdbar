import SwiftUI

/** Sets the platform pointer while the mouse is inside a clickable surface. */
package struct PointerCatcherKey: EnvironmentKey {
    package static let defaultValue: @MainActor (Bool) -> Void = { _ in }
}
