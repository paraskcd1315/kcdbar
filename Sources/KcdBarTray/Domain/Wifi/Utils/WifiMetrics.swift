import CoreGraphics
import Foundation

package enum WifiMetrics {
    package static let strongRssi = -60
    package static let fairRssi = -70
    package static let weakRssi = -80

    package static let symbol = "wifi"
    package static let slashSymbol = "wifi.slash"

    package static let unknownLevel = 1.0
    package static let fairLevel = 0.66
    package static let weakLevel = 0.33
    package static let faintLevel = 0.1
    package static let lockSymbol = "lock.fill"
    package static let chevronSymbol = "chevron.right"

    package static let rowGlyphSize: CGFloat = 20
    package static let rescanInterval: TimeInterval = 20
    package static let rowHeight: CGFloat = 28
    package static let headerHeight: CGFloat = 26

    package static func listHeight(rows: Int, cap: CGFloat) -> CGFloat {
        min(CGFloat(rows) * rowHeight, cap)
    }
}
