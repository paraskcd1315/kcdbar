import SwiftUI

/** Builds the platform view that reports a middle click. */
package struct MiddleClickCatcherKey: EnvironmentKey {
    package static let defaultValue: @MainActor (@escaping () -> Void) -> AnyView = { _ in
        AnyView(EmptyView())
    }
}
