// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
