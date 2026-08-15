import CoreGraphics
import Foundation

enum WifiMetrics {
    static let strongRssi = -60
    static let fairRssi = -70
    static let weakRssi = -80

    static let slashSymbol = "wifi.slash"
    static let lockSymbol = "lock.fill"
    static let chevronSymbol = "chevron.right"

    static let rowGlyphSize: CGFloat = 20
    static let rescanInterval: TimeInterval = 20
    static let rowHeight: CGFloat = 28
    static let headerHeight: CGFloat = 26

    static func listHeight(rows: Int, cap: CGFloat) -> CGFloat {
        min(CGFloat(rows) * rowHeight, cap)
    }

    static func symbol(bars: Int) -> String {
        switch bars {
        case 3: "wifi"
        case 2: "wifi.exclamationmark"
        case 1: "wifi.exclamationmark"
        default: "wifi.slash"
        }
    }
}
