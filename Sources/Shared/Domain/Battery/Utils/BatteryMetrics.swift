import CoreGraphics
import Foundation

enum BatteryMetrics {
    static let criticalPercentage = 10
    static let warningPercentage = 25
    static let fullPercentage = 100

    static let pillWidth: CGFloat = 30
    static let pillHeight: CGFloat = 14
    static let pillRadius: CGFloat = 4
    static let capWidth: CGFloat = 2
    static let capHeight: CGFloat = 6
    static let capGap: CGFloat = 1.5
    static let pillBorderWidth: CGFloat = 1
    static let minimumFill: CGFloat = 0.06

    static let significantEnergyImpact = 20.0
    static let significantEnergyLimit = 5
    static let sampleInterval: TimeInterval = 60
    static let panelWidth: CGFloat = 240
    static let panelGap: CGFloat = 8
}
