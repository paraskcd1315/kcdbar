import Testing
@testable import KcdBarTaskbar

struct ApplicationFolderPreviewTests {
    private func applications(_ count: Int) -> [InstalledApplication] {
        (0..<count).map {
            InstalledApplication(
                bundleIdentifier: "com.example.app\($0)",
                displayName: "App \($0)",
                path: "/Applications/App\($0).app"
            )
        }
    }

    @Test func afewAppsEachTakeTheirOwnCell() {
        let cells = ApplicationFolderPreview.cells(of: applications(3))

        #expect(cells.count == 3)
        #expect(cells.allSatisfy { $0.count == 1 })
    }

    @Test func exactlyAFullFaceIsStillOnePerCell() {
        let cells = ApplicationFolderPreview.cells(of: applications(StartMenuMetrics.folderPreviewCount))

        #expect(cells.count == StartMenuMetrics.folderPreviewCount)
        #expect(cells.allSatisfy { $0.count == 1 })
    }

    @Test func theOverflowSharesTheLastCellRatherThanDisappearing() {
        let cells = ApplicationFolderPreview.cells(of: applications(9))

        #expect(cells.count == StartMenuMetrics.folderPreviewCount)
        #expect(cells.dropLast().allSatisfy { $0.count == 1 })
        #expect(cells.last?.count == 9 - (StartMenuMetrics.folderPreviewCount - 1))
    }

    @Test func anEmptyCategoryDrawsNoCells() {
        #expect(ApplicationFolderPreview.cells(of: []).isEmpty)
    }
}
