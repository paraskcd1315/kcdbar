import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreAccordion<Content: View>: View {
    package let titleKey: LocalizedStringKey
    @ViewBuilder package let content: Content

    @State private var isExpanded = false

    package init(titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.content = content()
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ControlCentreAccordionHeader(titleKey: titleKey, isExpanded: isExpanded) {
                withAnimation(KbMotion.standard) { isExpanded.toggle() }
            }
            if isExpanded {
                content
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
    }
}
