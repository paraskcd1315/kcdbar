import SwiftUI

package struct TaskbarEntryMenu: View {
    package let entry: TaskbarEntryModel
    package let onTogglePin: () -> Void
    package let onCloseWindow: () -> Void
    package let onQuit: () -> Void

    package var body: some View {
        Button(action: onTogglePin) {
            Label(
                entry.isPinned ? "taskbar.menu.unpin" : "taskbar.menu.pin",
                systemImage: entry.isPinned
                    ? TaskbarMenuMetrics.unpinSymbol
                    : TaskbarMenuMetrics.pinSymbol
            )
        }
        if !entry.isLauncher {
            Divider()
            Button(action: onCloseWindow) {
                Label("taskbar.menu.close", systemImage: TaskbarMenuMetrics.closeSymbol)
            }
            .keyboardShortcut("w")
        }
        if entry.instanceCount > 0 {
            Divider()
            Button(role: .destructive, action: onQuit) {
                Label("taskbar.menu.quit", systemImage: TaskbarMenuMetrics.quitSymbol)
            }
            .keyboardShortcut("q")
        }
    }
}
