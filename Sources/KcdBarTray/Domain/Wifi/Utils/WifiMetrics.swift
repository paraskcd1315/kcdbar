import CoreGraphics
import Foundation

package enum WifiMetrics {
    package static let strongRssi = -60
    package static let fairRssi = -70
    package static let weakRssi = -80

    package static let slashSymbol = "wifi.slash"
    package static let lockSymbol = "lock.fill"
    package static let chevronSymbol = "chevron.right"

    package static let rowGlyphSize: CGFloat = 20
    package static let rescanInterval: TimeInterval = 20
    package static let rowHeight: CGFloat = 28
    package static let headerHeight: CGFloat = 26

    package static func listHeight(rows: Int, cap: CGFloat) -> CGFloat {
        min(CGFloat(rows) * rowHeight, cap)
    }

    package static func symbol(bars: Int) -> String {
        switch bars {
        case 3: "wifi"
        case 2: "wifi.exclamationmark"
        case 1: "wifi.exclamationmark"
        default: "wifi.slash"
        }
    }
}
