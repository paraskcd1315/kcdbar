import Testing

@testable import KcdBarTaskbar

struct ApplicationQuitPolicyTests {
    @Test func anOrdinaryApplicationCanBeQuit() {
        #expect(ApplicationQuitPolicy.canQuit(bundleIdentifier: "com.google.Chrome"))
    }

    @Test func theFinderAndTheOtherSystemSurfacesCannot() {
        #expect(ApplicationQuitPolicy.canQuit(bundleIdentifier: "com.apple.finder") == false)
        #expect(ApplicationQuitPolicy.canQuit(bundleIdentifier: "com.apple.dock") == false)
    }

    @Test func anEntryWithoutABundleIdentifierCannot() {
        #expect(ApplicationQuitPolicy.canQuit(bundleIdentifier: nil) == false)
    }
}
