import SwiftUI

package enum KbGradients {
    package static let mark = LinearGradient(
        colors: [KbColors.onSurface, KbColors.brand],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
