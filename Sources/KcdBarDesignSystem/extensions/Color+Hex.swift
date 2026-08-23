import SwiftUI

extension Color {
    /** A colour from the `#RRGGBB` a tracker states, or nothing where it states something else. */
    package init?(hex: String) {
        let digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

        guard digits.count == 6, let value = UInt32(digits, radix: 16) else { return nil }

        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}
