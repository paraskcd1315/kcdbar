/** The running build's version, read as milestone, feature and fix, with the commit it came from. */
package struct AppVersion: Sendable, Equatable {
    package let marketing: String
    package let build: String
    package let commit: String

    package init(marketing: String, build: String, commit: String) {
        self.marketing = marketing
        self.build = build
        self.commit = commit
    }

    package var components: AppVersionComponents? {
        AppVersionComponents(marketing)
    }

    package var isPrerelease: Bool {
        (components?.milestone ?? 0) == 0
    }

    package var short: String {
        "\(marketing) (\(build))"
    }

    package var full: String {
        commit.isEmpty ? short : "\(short) · \(commit)"
    }
}
