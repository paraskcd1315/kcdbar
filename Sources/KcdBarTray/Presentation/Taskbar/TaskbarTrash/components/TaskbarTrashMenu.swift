import SwiftUI

package struct TaskbarTrashMenu: View {
    package let isEmpty: Bool
    package let onOpen: () -> Void
    package let onEmpty: () -> Void

    package var body: some View {
        Button(action: onOpen) {
            Label("trash.open", systemImage: TrashSymbols.openSymbol)
        }
        if !isEmpty {
            Divider()
            Button(role: .destructive, action: onEmpty) {
                Label("trash.empty", systemImage: TrashSymbols.emptySymbol)
            }
        }
    }
}
