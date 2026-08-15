import CoreGraphics

package enum TimerReadoutMetrics {
    package static let secondsInMinute = 60
    package static let secondsInHour = 3600
    package static let tick: Double = 1
    package static let glyphSymbol = "timer"
    package static let billableSymbol = "creditcard"
    package static let openSymbol = "arrow.up.forward.app"
    package static let labelWidth: CGFloat = 120
    package static let panelWidth: CGFloat = 300
    package static let rowSpacing: CGFloat = 10
    package static let rowHeight: CGFloat = 44
    package static let listMaxHeight: CGFloat = 260

    package static func listHeight(rows: Int) -> CGFloat {
        let wanted = CGFloat(max(rows, 1)) * rowHeight + CGFloat(max(rows - 1, 0)) * rowSpacing

        return min(wanted, listMaxHeight)
    }
}
