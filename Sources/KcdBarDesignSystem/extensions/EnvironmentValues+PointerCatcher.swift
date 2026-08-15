import SwiftUI

package extension EnvironmentValues {
    var pointerCatcher: @MainActor (Bool) -> Void {
        get { self[PointerCatcherKey.self] }
        set { self[PointerCatcherKey.self] = newValue }
    }
}
