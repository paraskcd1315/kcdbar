import Foundation
import Testing
@testable import KcdBarTaskbar

struct ApplicationBundleFilterTests {
    private let roots = ApplicationDirectories.roots(home: URL(fileURLWithPath: "/Users/paras"))

    @Test func anApplicationInALauncherRootIsListed() {
        #expect(ApplicationBundleFilter.isListable(path: "/Applications/Safari.app", underRoots: roots))
        #expect(ApplicationBundleFilter.isListable(path: "/System/Applications/Mail.app", underRoots: roots))
        #expect(ApplicationBundleFilter.isListable(path: "/Users/paras/Applications/Paste.app", underRoots: roots))
    }

    @Test func aVendorFolderInsideARootIsStillInsideIt() {
        let nested = "/Applications/Adobe After Effects 2025/Adobe After Effects 2025.app"
        let setapp = "/Applications/Setapp/Paste.app"

        #expect(ApplicationBundleFilter.isListable(path: nested, underRoots: roots))
        #expect(ApplicationBundleFilter.isListable(path: setapp, underRoots: roots))
    }

    @Test func aHelperInsideAnotherBundleIsNotAnApplication() {
        let helper = "/Applications/Xcode.app/Contents/Applications/Instruments.app"

        #expect(!ApplicationBundleFilter.isListable(path: helper, underRoots: roots))
    }

    @Test func buildProductsAndCachesStayOutOfTheList() {
        let paths = [
            "/Users/paras/Developer/kcdbar/build/Build/Products/Debug/KCDBar.app",
            "/Users/paras/Library/Developer/Xcode/DerivedData/x/Build/Products/Debug/App.app",
            "/Users/paras/Library/Application Support/Figma/FigmaAgent.app",
            "/System/Library/CoreServices/Finder.app",
            "/Library/Application Support/Helper.app"
        ]

        for path in paths {
            #expect(!ApplicationBundleFilter.isListable(path: path, underRoots: roots))
        }
    }

    @Test func aRootIsNotItsOwnPrefixTwin() {
        #expect(!ApplicationBundleFilter.isListable(path: "/ApplicationsOld/Thing.app", underRoots: roots))
    }

    @Test func theBackgroundFlagIsReadInEveryShapeAPlistWritesIt() {
        #expect(ApplicationBundleFilter.isTrue(true))
        #expect(ApplicationBundleFilter.isTrue("1"))
        #expect(ApplicationBundleFilter.isTrue("YES"))
        #expect(ApplicationBundleFilter.isTrue("true"))
        #expect(!ApplicationBundleFilter.isTrue(false))
        #expect(!ApplicationBundleFilter.isTrue("0"))
        #expect(!ApplicationBundleFilter.isTrue(nil))
    }
}
