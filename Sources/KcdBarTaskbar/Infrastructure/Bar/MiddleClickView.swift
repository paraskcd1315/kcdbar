import AppKit
import SwiftUI

package struct MiddleClickView: NSViewRepresentable {
    package let action: () -> Void

    package func makeNSView(context: Context) -> MiddleClickCatchingView {
        let view = MiddleClickCatchingView()
        view.action = action

        return view
    }

    package func updateNSView(_ view: MiddleClickCatchingView, context: Context) {
        view.action = action
    }
}
