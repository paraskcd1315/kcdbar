import AppKit
import SwiftUI

struct MiddleClickView: NSViewRepresentable {
    let action: () -> Void

    func makeNSView(context: Context) -> MiddleClickCatchingView {
        let view = MiddleClickCatchingView()
        view.action = action

        return view
    }

    func updateNSView(_ view: MiddleClickCatchingView, context: Context) {
        view.action = action
    }
}
