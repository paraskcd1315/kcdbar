import Foundation

package enum BarPresetNaming {
    package static let copySuffix = "copy"

    package static func copyName(of base: String, taken: Set<String>) -> String {
        let wanted = "\(base) \(copySuffix)"
        guard taken.contains(wanted) else { return wanted }

        var index = 2
        while taken.contains("\(wanted) \(index)") {
            index += 1
        }
        return "\(wanted) \(index)"
    }

    package static func trimmed(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    package static func isAcceptable(_ name: String, taken: Set<String>) -> Bool {
        let candidate = trimmed(name)
        guard !candidate.isEmpty else { return false }
        return !taken.contains(candidate)
    }
}
