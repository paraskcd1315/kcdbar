import CoreGraphics
import Foundation

enum BatteryMetrics {
    static let criticalPercentage = 10
    static let warningPercentage = 25
    static let fullPercentage = 100

    static let pillWidth: CGFloat = 25
    static let pillHeight: CGFloat = 12
    static let pillRadius: CGFloat = 3.5
    static let capWidth: CGFloat = 2
    static let capHeight: CGFloat = 5
    static let capGap: CGFloat = 1.5
    static let pillBorderWidth: CGFloat = 1
    static let minimumFill: CGFloat = 0.06

    static let significantEnergyImpact = 20.0
    static let significantEnergyLimit = 5
    static let sampleInterval: TimeInterval = 60
    static let panelWidth: CGFloat = 300
    static let panelGap: CGFloat = 6
    static let arrowSize = CGSize(width: 18, height: 9)
    static let dividerHeight: CGFloat = 1
    static let collapsedScale: CGFloat = 0.55
    static let collapseMilliseconds = 280
}
