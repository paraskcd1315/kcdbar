import SwiftUI

package struct SettingsPaneLink: View {
    package let pane: SettingsPane

    package init(pane: SettingsPane) {
        self.pane = pane
    }

    package var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(pane.title)
                Text(pane.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: pane.symbol)
                .frame(width: SettingsMetrics.symbolWidth)
        }
    }
}
