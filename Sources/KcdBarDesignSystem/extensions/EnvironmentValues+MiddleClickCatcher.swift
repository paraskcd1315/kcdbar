import SwiftUI

package extension EnvironmentValues {
    var middleClickCatcher: @MainActor (@escaping () -> Void) -> AnyView {
        get { self[MiddleClickCatcherKey.self] }
        set { self[MiddleClickCatcherKey.self] = newValue }
    }
}
