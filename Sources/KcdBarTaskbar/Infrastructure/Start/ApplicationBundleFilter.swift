import Foundation

/** Which application bundles a launcher lists — not helpers, not agents, not build products. */
package enum ApplicationBundleFilter {
    package static func isListable(path: String, underRoots roots: [URL]) -> Bool {
        guard !path.contains(ApplicationBundleMetrics.embeddedMarker) else { return false }

        return roots.contains { path.hasPrefix($0.path + "/") }
    }

    package static func isBackgroundOnly(_ bundle: Bundle) -> Bool {
        ApplicationBundleMetrics.backgroundKeys.contains {
            isTrue(bundle.object(forInfoDictionaryKey: $0))
        }
    }

    package static func isTrue(_ value: Any?) -> Bool {
        if let flag = value as? Bool { return flag }
        if let number = value as? NSNumber { return number.boolValue }
        if let text = value as? String {
            return ApplicationBundleMetrics.trueStrings.contains(text.lowercased())
        }

        return false
    }
}
