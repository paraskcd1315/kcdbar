import Foundation

package enum ApplicationDirectories {
    package static let bundleExtension = "app"

    package static func roots(home: URL) -> [URL] {
        [
            URL(fileURLWithPath: "/Applications"),
            URL(fileURLWithPath: "/System/Applications"),
            home.appending(path: "Applications"),
        ]
    }
}
