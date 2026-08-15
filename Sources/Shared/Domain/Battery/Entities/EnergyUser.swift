import Foundation

/** An application drawing significant power, as macOS reports it. */
struct EnergyUser: Equatable, Sendable, Identifiable {
    let name: String
    let impact: Double

    var id: String { name }
}
