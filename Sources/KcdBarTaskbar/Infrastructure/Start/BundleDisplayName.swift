import AppKit
import Foundation

/** The name the user sees, preferring the bundle's localized display name. */
package enum BundleDisplayName {
    package static func of(_ bundle: Bundle, url: URL) -> String {
        let localized = bundle.localizedInfoDictionary?[kCFBundleNameKey as String] as? String
        let display = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let name = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        let found = localized ?? display ?? name ?? FileManager.default.displayName(atPath: url.path)

        return ApplicationDisplayName.cleaned(found)
    }
}
