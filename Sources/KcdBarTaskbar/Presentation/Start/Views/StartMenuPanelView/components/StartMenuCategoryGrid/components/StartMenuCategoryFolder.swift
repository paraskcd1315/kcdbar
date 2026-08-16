import KcdBarDesignSystem
import SwiftUI

package struct StartMenuCategoryFolder: View {
    package let section: ApplicationSection
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onOpen: () -> Void

    @State private var isHovered = false

    package var body: some View {
        VStack(spacing: KbSpacing.s3) {
            LazyVGrid(columns: columns, spacing: StartMenuMetrics.folderInnerSpacing) {
                ForEach(Array(cells.enumerated()), id: \.offset) { _, cell in
                    StartMenuFolderCell(applications: cell, icons: icons, onLaunch: onLaunch)
                }
            }
            .padding(StartMenuMetrics.folderInnerSpacing)
            .frame(
                width: StartMenuMetrics.folderCardSize,
                height: StartMenuMetrics.folderCardSize
            )
            .background(
                KbColors.onSurface.opacity(
                    isHovered
                        ? StartMenuMetrics.hoverFillOpacity
                        : StartMenuMetrics.folderFillOpacity
                ),
                in: shape
            )
            .kbTappable(in: shape, perform: onOpen)
            Text(LocalizedStringKey(section.titleKey ?? section.key))
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .frame(height: StartMenuMetrics.folderLabelHeight)
        }
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var cells: [[InstalledApplication]] {
        ApplicationFolderPreview.cells(of: section.applications)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: StartMenuMetrics.folderInnerSpacing),
            count: StartMenuMetrics.folderColumns
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.xl, style: .continuous)
    }
}
