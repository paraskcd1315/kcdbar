/** A project a day's entries were booked against, carrying the colour its blocks are drawn in. */
package struct DayProject: Equatable, Sendable, Identifiable {
    package let id: Int
    package let name: String
    package let clientName: String?
    package let colour: String

    package init(id: Int, name: String, clientName: String?, colour: String) {
        self.id = id
        self.name = name
        self.clientName = clientName
        self.colour = colour
    }
}
