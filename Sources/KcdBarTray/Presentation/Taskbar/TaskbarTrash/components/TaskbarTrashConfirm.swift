import SwiftUI

package struct TaskbarTrashConfirm: ViewModifier {
    @Binding package var isAsking: Bool
    package let onConfirm: () -> Void

    package func body(content: Content) -> some View {
        content.alert("trash.confirm.title", isPresented: $isAsking) {
            Button("trash.confirm.cancel", role: .cancel) {}
            Button("trash.confirm.empty", role: .destructive, action: onConfirm)
        } message: {
            Text("trash.confirm.message")
        }
    }
}
