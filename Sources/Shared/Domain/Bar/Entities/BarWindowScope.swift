/** Which windows a bar shows. */
enum BarWindowScope: String, Codable, CaseIterable, Sendable {
    case thisDisplay
    case allDisplays
}
