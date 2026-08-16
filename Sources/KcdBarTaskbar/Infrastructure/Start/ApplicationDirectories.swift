import Foundation

package enum ApplicationDirectories {
    package static let bundleExtension = "app"

    package static func roots(home: URL) -> [URL] {
        [
            URL(fileURLWithPath: "/Applications"),
            URL(fileURLWithPath: "/Applications/Utilities"),
            URL(fileURLWithPath: "/System/Applications"),
            URL(fileURLWithPath: "/System/Applications/Utilities"),
            home.appending(path: "Applications"),
        ]
    }
}
