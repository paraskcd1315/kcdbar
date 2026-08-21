import CoreGraphics
import KcdBarDesignSystem
import SwiftUI

package enum AboutMetrics {
    package static let windowWidth: CGFloat = 380
    package static let windowHeight: CGFloat = 300
    package static let iconSide: CGFloat = 96
    package static let contentPadding: CGFloat = KbSpacing.s8
    package static let stackSpacing: CGFloat = KbSpacing.s5
    package static let identitySpacing: CGFloat = KbSpacing.s2
    package static let appName = Font.system(size: 20, weight: .semibold)
    package static let tagline = Font.system(size: 12, weight: .regular)
    package static let version = Font.system(size: 11, weight: .regular)
    package static let commit = Font.system(size: 10, weight: .regular).monospaced()
    package static let badge = Font.system(size: 9, weight: .bold)
    package static let badgeCornerRadius: CGFloat = 4
    package static let badgePaddingHorizontal: CGFloat = KbSpacing.s3
    package static let badgePaddingVertical: CGFloat = KbSpacing.s1
}
