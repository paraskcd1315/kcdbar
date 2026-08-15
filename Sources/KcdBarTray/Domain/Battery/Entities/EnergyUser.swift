import Foundation

/** An application drawing significant power, as macOS reports it. */
package struct EnergyUser: Equatable, Sendable, Identifiable {
    package let name: String
    package let impact: Double

    package var id: String { name }
}
