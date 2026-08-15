import KcdBarDesignSystem
import SwiftUI

package struct EthernetDetail: View {
    package let name: String
    package let detail: NetworkDetail?
    package let onBack: () -> Void
    package let onCopy: (String) -> Void
    package let onOpenSettings: () -> Void

    package init(
        name: String,
        detail: NetworkDetail?,
        onBack: @escaping () -> Void,
        onCopy: @escaping (String) -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.name = name
        self.detail = detail
        self.onBack = onBack
        self.onCopy = onCopy
        self.onOpenSettings = onOpenSettings
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            ControlCentreDetailTitle(title: name, onBack: onBack)
            ControlCentreDetailBody {
                if let detail {
                    ControlCentreAccordion(titleKey: "network.details") {
                        NetworkDetailList(detail: detail, onCopy: onCopy)
                    }
                }
            }
            ControlCentreSettingsRow(titleKey: "network.settings", onOpen: onOpenSettings)
        }
    }
}
