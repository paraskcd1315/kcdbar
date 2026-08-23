import KcdBarDesignSystem
import SwiftUI

package struct DayEntryBlock: View {
    package let block: DayBlock
    package let project: DayProject?
    package let now: Date
    package let height: CGFloat
    package let onOpen: (DayEntry) -> Void

    package init(
        block: DayBlock,
        project: DayProject?,
        now: Date,
        height: CGFloat,
        onOpen: @escaping (DayEntry) -> Void
    ) {
        self.block = block
        self.project = project
        self.now = now
        self.height = height
        self.onOpen = onOpen
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DayEntryBlockTitle(entry: block.entry, tone: tone)

            if height >= DayPanelMetrics.projectFloor, let project {
                Text(project.name)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(tone)
                    .lineLimit(1)
            }

            if height >= DayPanelMetrics.rangeFloor {
                Text(DayFormatting.range(from: block.entry.startedAt, to: block.entry.endedAt(by: now)))
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(DayPanelMetrics.blockPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tone.opacity(DayPanelMetrics.blockTint), in: shape)
        .overlay {
            shape.strokeBorder(
                tone.opacity(DayPanelMetrics.blockEdge),
                lineWidth: DayPanelMetrics.ruleHeight
            )
        }
        .kbTappable(in: shape, perform: open)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DayPanelMetrics.blockRadius, style: .continuous)
    }

    private var tone: Color {
        project.flatMap { Color(hex: $0.colour) } ?? KbColors.onSurfaceMuted
    }

    private func open() {
        guard block.entry.opensATicket else { return }

        onOpen(block.entry)
    }
}
