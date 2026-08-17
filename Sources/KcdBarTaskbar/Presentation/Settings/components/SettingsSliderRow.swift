import SwiftUI

package struct SettingsSliderRow: View {
    package let title: LocalizedStringKey
    package let range: ClosedRange<CGFloat>
    @Binding package var value: CGFloat

    package init(title: LocalizedStringKey, range: ClosedRange<CGFloat>, value: Binding<CGFloat>) {
        self.title = title
        self.range = range
        self._value = value
    }

    package var body: some View {
        LabeledContent {
            HStack {
                Slider(value: $value, in: range, step: 1)
                Text(verbatim: "\(Int(value))")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        } label: {
            Text(title)
        }
    }
}
