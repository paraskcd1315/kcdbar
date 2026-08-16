import CoreGraphics

package enum StartMenuMetrics {
    package static let otherSectionKey = "#"
    package static let panelWidth: CGFloat = 420
    package static let bodyMaxHeight: CGFloat = 460
    package static let pinnedColumns = 5
    package static let pinnedIconSize: CGFloat = 44
    package static let pinnedTileHeight: CGFloat = 92
    package static let pinnedTilePadding: CGFloat = 8
    package static let rowIconSize: CGFloat = 30
    package static let rowSpacing: CGFloat = 2
    package static let sectionSpacing: CGFloat = 6
    package static let rowHeight: CGFloat = 44
    package static let sectionHeadingHeight: CGFloat = 28

    package static func bodyHeight(pinned: Int, rows: Int, sections: Int) -> CGFloat {
        min(pinnedHeight(pinned) + listHeight(rows: rows, sections: sections), bodyMaxHeight)
    }

    package static func pinnedHeight(_ pinned: Int) -> CGFloat {
        guard pinned > 0 else { return 0 }
        let lines = CGFloat((pinned + pinnedColumns - 1) / pinnedColumns)

        return sectionHeadingHeight
            + lines * pinnedTileHeight
            + max(lines - 1, 0) * sectionSpacing
            + sectionSpacing
    }

    package static func listHeight(rows: Int, sections: Int) -> CGFloat {
        let bands = CGFloat(max(sections, 0))

        return sectionHeadingHeight
            + CGFloat(max(rows, 1)) * rowHeight
            + bands * sectionHeadingHeight
            + max(bands - 1, 0) * sectionSpacing
    }
    package static let searchGlyph = "magnifyingglass"
    package static let placeholderGlyph = "app.dashed"
    package static let hoverFillOpacity: Double = 0.12
    package static let skeletonRowCount = 20
    package static let skeletonRowsPerBand = 4
    package static let skeletonHeadingWidth: CGFloat = 10
    package static let skeletonLabelWidths: [CGFloat] = [148, 96, 184, 120, 162, 108, 138]

    package static func skeletonLabelWidth(at index: Int) -> CGFloat {
        skeletonLabelWidths[index % skeletonLabelWidths.count]
    }

    package static func skeletonStartsBand(at index: Int) -> Bool {
        index % skeletonRowsPerBand == 0
    }

    package static var skeletonBandCount: Int {
        (skeletonRowCount + skeletonRowsPerBand - 1) / skeletonRowsPerBand
    }
    package static let powerGlyphSize: CGFloat = 13
    package static let powerButtonSize: CGFloat = 28
    package static let groupingTitlePrefix = "start.group."
    package static let listGlyph = "list.bullet"
    package static let gridGlyph = "square.grid.2x2"
    package static let indexGlyph = "textformat.abc"
    package static let controlsHeight: CGFloat = 24
    package static let gridColumns = 4
    package static let gridIconSize: CGFloat = 40
    package static let gridTileHeight: CGFloat = 86
    package static let railWidth: CGFloat = 14
    package static let railLetterHeight: CGFloat = 11
    package static let letterGridColumns = 4
    package static let letterGridCellSize: CGFloat = 34
    package static let disabledLetterOpacity: Double = 0.25

    package static func gridLines(of sections: [ApplicationSection]) -> Int {
        sections.reduce(0) { $0 + (($1.applications.count + gridColumns - 1) / gridColumns) }
    }

    package static func gridHeight(lines: Int, sections: Int) -> CGFloat {
        let bands = CGFloat(max(sections, 0))
        let rows = CGFloat(max(lines, 1))

        return sectionHeadingHeight
            + rows * gridTileHeight
            + bands * sectionHeadingHeight
            + max(bands - 1, 0) * sectionSpacing
    }
}
