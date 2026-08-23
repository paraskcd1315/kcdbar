import SwiftUI

/** The four colours a surface's rim wears while an agent is working. */
package enum KbStreakColours {
    package static let orange = Color(red: 0.98, green: 0.58, blue: 0.24)
    package static let purple = Color(red: 0.62, green: 0.44, blue: 0.98)
    package static let pink = Color(red: 0.98, green: 0.42, blue: 0.66)
    package static let fuchsia = Color(red: 0.85, green: 0.32, blue: 0.90)

    package static let every = [orange, purple, pink, fuchsia]

    package static let waiting = Color(red: 0.98, green: 0.71, blue: 0.20)
}
