/** A project a day's entries were booked against, as the channel writes it. */
package struct DayProjectSignal: Codable, Sendable, Equatable {
    package let id: Int
    package let name: String
    package let clientName: String?
    package let colour: String

    package func toEntity() -> DayProject {
        DayProject(id: id, name: name, clientName: clientName, colour: colour)
    }
}
