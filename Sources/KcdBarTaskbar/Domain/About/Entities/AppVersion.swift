/** The running build's marketing version, build number and commit. */
package struct AppVersion: Sendable, Equatable {
    package let marketing: String
    package let build: String
    package let commit: String

    package init(marketing: String, build: String, commit: String) {
        self.marketing = marketing
        self.build = build
        self.commit = commit
    }

    package var isPrerelease: Bool {
        marketing.hasPrefix("0.")
    }

    package var short: String {
        "\(marketing) (\(build))"
    }

    package var full: String {
        commit.isEmpty ? short : "\(short) · \(commit)"
    }
}
