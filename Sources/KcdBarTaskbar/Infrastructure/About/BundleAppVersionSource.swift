import Foundation

/** Reads the running build's version out of the main bundle. */
package struct BundleAppVersionSource: AppVersionPort {
    private let bundle: Bundle

    package init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    package var current: AppVersion {
        AppVersion(
            marketing: string(AppVersionKeys.marketing),
            build: string(AppVersionKeys.build),
            commit: string(AppVersionKeys.commit)
        )
    }

    private func string(_ key: String) -> String {
        bundle.object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
