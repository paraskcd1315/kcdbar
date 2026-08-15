/** What the bar does about windows that would sit underneath it. */
enum BarOverlapPolicy: String, Codable, CaseIterable, Sendable {
    case float
    case pushDisplayFillingWindows
}
