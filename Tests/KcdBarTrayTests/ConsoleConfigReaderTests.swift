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

struct ConsoleConfigReaderTests {
    private func written(_ json: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("cc-console-\(UUID().uuidString).json")
        try Data(json.utf8).write(to: url)

        return url
    }

    @Test func aHostIsLookedUpLoweredAndWithoutItsLocalSuffix() {
        let names = ConsoleConfigReader.names(of: "MacBook-Air-de-ParasKCD.local")

        #expect(names.first == "macbook-air-de-paraskcd.local")
        #expect(names.contains("macbook-air-de-paraskcd"))
    }

    @Test func aBareHostStillReachesItsLocalEntry() {
        #expect(ConsoleConfigReader.names(of: "kcdmachine-1").contains("kcdmachine-1.local"))
    }

    @Test func thisMachinesPortAndTokenAreFound() throws {
        let url = try written(
            """
            {"machines":{"macbook-air-de-paraskcd.local":\
            {"server":{"port":62882,"token":"secret"}}}}
            """)

        let server = ConsoleConfigReader.server(hostName: "MacBook-Air-de-ParasKCD.local", at: url)

        #expect(server == ConsoleServer(port: 62882, token: "secret"))
    }

    @Test func anEntryListeningOnNoPortIsSkippedForOneThatIs() throws {
        let url = try written(
            """
            {"machines":{\
            "macbook-air-de-paraskcd":{"server":{"port":0,"token":"tailnet"}},\
            "macbook-air-de-paraskcd.local":{"server":{"port":62882,"token":"local"}}}}
            """)

        let server = ConsoleConfigReader.server(hostName: "macbook-air-de-paraskcd", at: url)

        #expect(server?.token == "local")
    }

    @Test func anotherMachinesEntryIsNeverBorrowed() throws {
        let url = try written(
            """
            {"machines":{"kcdmachine-1.local":{"server":{"port":1234,"token":"theirs"}}}}
            """)

        #expect(ConsoleConfigReader.server(hostName: "macbook-air-de-paraskcd.local", at: url) == nil)
    }

    @Test func noConfigAtAllIsNotAnError() {
        let missing = FileManager.default.temporaryDirectory
            .appendingPathComponent("absent-\(UUID().uuidString).json")

        #expect(ConsoleConfigReader.server(hostName: "anything", at: missing) == nil)
    }

    @Test func theTicketUrlIsLoopbackAndNothingElse() {
        let server = ConsoleServer(port: 62882, token: "secret")

        #expect(server.ticketUrl?.absoluteString == "http://127.0.0.1:62882/ticket")
    }
}
