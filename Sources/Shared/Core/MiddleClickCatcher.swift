import SwiftUI

/** Builds the platform view that reports a middle click. */
struct MiddleClickCatcherKey: EnvironmentKey {
    static let defaultValue: @MainActor (@escaping () -> Void) -> AnyView = { _ in
        AnyView(EmptyView())
    }
}

extension EnvironmentValues {
    var middleClickCatcher: @MainActor (@escaping () -> Void) -> AnyView {
        get { self[MiddleClickCatcherKey.self] }
        set { self[MiddleClickCatcherKey.self] = newValue }
    }
}
