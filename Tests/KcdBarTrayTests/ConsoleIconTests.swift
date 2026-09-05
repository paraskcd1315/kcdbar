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

import SwiftUI
import Testing

@testable import KcdBarTray

@MainActor
private struct FakeConsoleIconPort: ConsoleIconPort {
    let answer: Image?

    func image() -> Image? { answer }
}

@MainActor
struct ConsoleIconReaderTests {
    @Test func theReaderAnswersNilForAnUnknownBundleId() {
        let reader = ConsoleIconReader(bundleIdentifier: "com.paraskcd.kcdbar-icon-reader-tests-unknown")

        #expect(reader.image() == nil)
    }
}

@MainActor
struct ConsoleGlyphTests {
    @Test func itPicksTheGlyphWhenThePortAnswersNil() {
        let port = FakeConsoleIconPort(answer: nil)

        #expect(ConsoleGlyph(image: port.image()).isShowingIcon == false)
    }

    @Test func itPicksTheImageWhenThePortAnswersOne() {
        let port = FakeConsoleIconPort(answer: Image(systemName: "app.fill"))

        #expect(ConsoleGlyph(image: port.image()).isShowingIcon)
    }
}
