/** Whether the bar sits against its screen edge or floats clear of it. */
enum BarAttachment: String, Codable, CaseIterable, Sendable {
    case edgeAttached
    case floating
}
