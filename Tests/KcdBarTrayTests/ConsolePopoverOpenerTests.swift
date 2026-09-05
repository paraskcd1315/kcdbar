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

import Foundation
import Testing

@testable import KcdBarTray

struct ConsolePopoverOpenerTests {
    private let anchor = CGRect(x: 640, y: 0, width: 46, height: 52)

    @Test func aConsoleThatStartedAfterUsIsStillFound() async {
        let started = ConsoleServer(port: 62029, token: "t")
        let answers = ConsoleServerAnswers(values: [nil, started])
        let opener = ConsolePopoverOpener(read: { answers.next() })

        #expect(opener.isAvailable == false)
        #expect(opener.isAvailable)
    }

    @Test func noConsoleAtAllIsRefusedRatherThanAttempted() async {
        let opener = ConsolePopoverOpener(read: { nil })

        let opened = await opener.open(anchor: anchor)

        #expect(opened == false)
    }

    @Test func aConsoleThatStopsIsNoLongerReportedAvailable() {
        let answers = ConsoleServerAnswers(values: [ConsoleServer(port: 62029, token: "t"), nil])
        let opener = ConsolePopoverOpener(read: { answers.next() })

        #expect(opener.isAvailable)
        #expect(opener.isAvailable == false)
    }

    @Test func thePortIsReadEveryTimeRatherThanOnceAtLaunch() async {
        let answers = ConsoleServerAnswers(values: [nil, nil])
        let opener = ConsolePopoverOpener(read: { answers.next() })

        _ = opener.isAvailable
        _ = await opener.open(anchor: anchor)

        #expect(answers.taken == 2)
    }

    @Test func thePopoverUrlSitsBesideTheTicketUrlOnTheSamePort() {
        let server = ConsoleServer(port: 62029, token: "t")

        #expect(server.popoverUrl?.absoluteString == "http://127.0.0.1:62029/popover")
        #expect(server.ticketUrl?.host() == server.popoverUrl?.host())
    }
}
