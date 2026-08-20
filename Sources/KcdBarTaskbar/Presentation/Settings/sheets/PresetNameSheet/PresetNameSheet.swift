import KcdBarDesignSystem
import SwiftUI

package struct PresetNameSheet: View {
    package let request: BarPresetNamingRequest
    package let isAcceptable: (String) -> Bool
    package let onCommit: (String) -> Void
    package let onCancel: () -> Void

    @State private var name: String

    package init(
        request: BarPresetNamingRequest,
        isAcceptable: @escaping (String) -> Bool,
        onCommit: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.request = request
        self.isAcceptable = isAcceptable
        self.onCommit = onCommit
        self.onCancel = onCancel
        self._name = State(initialValue: request.proposed)
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s4) {
            Text(LocalizedStringKey.catalogue("settings.preset", request.reason.rawValue, "title"))
                .font(KbTypography.panelTitle)
            Text(LocalizedStringKey.catalogue("settings.preset", request.reason.rawValue, "detail"))
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .fixedSize(horizontal: false, vertical: true)
            TextField("settings.preset.name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onSubmit { commit() }
            HStack {
                Spacer()
                Button("settings.preset.cancel", role: .cancel, action: onCancel)
                    .keyboardShortcut(.cancelAction)
                Button(
                    LocalizedStringKey.catalogue("settings.preset", request.reason.rawValue, "confirm"),
                    action: commit
                )
                .keyboardShortcut(.defaultAction)
                .disabled(!isAcceptable(name))
            }
        }
        .padding(KbSpacing.s7)
        .frame(width: SettingsMetrics.sheetWidth)
    }

    private func commit() {
        guard isAcceptable(name) else { return }

        onCommit(name)
    }
}
