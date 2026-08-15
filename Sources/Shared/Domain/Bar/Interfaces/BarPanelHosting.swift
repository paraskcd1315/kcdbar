import SwiftUI

@MainActor
protocol BarPanelHosting: AnyObject {
    func present<Content: View>(preset: BarPreset, @ViewBuilder content: () -> Content)
    func dismiss()
}
