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

import CoreGraphics
import Foundation

private typealias GetBrightnessFn =
    @convention(c) (CGDirectDisplayID, UnsafeMutablePointer<Float>) -> Int32
private typealias SetBrightnessFn =
    @convention(c) (CGDirectDisplayID, Float) -> Int32
private typealias CanChangeBrightnessFn =
    @convention(c) (CGDirectDisplayID) -> Bool

/** Display brightness, reached through DisplayServices since no public API exposes it. */
@MainActor
package struct DisplayServicesBrightness: BrightnessPort {
    package init() {}

    private static let handle = dlopen(TrayPrivateFrameworks.displayServices, RTLD_LAZY)

    private static let get: GetBrightnessFn? =
        symbol(TrayPrivateFrameworks.getBrightness)
    private static let set: SetBrightnessFn? =
        symbol(TrayPrivateFrameworks.setBrightness)
    private static let canChange: CanChangeBrightnessFn? =
        symbol(TrayPrivateFrameworks.canChangeBrightness)

    package func state() -> BrightnessState {
        guard let get = Self.get, let display = Self.mainDisplay() else { return .unavailable }
        guard Self.canChange?(display) ?? false else { return .unavailable }

        var level = Float(0)
        guard get(display, &level) == 0 else { return .unavailable }

        return BrightnessState(isAvailable: true, level: Double(level))
    }

    package func setLevel(_ level: Double) {
        guard let set = Self.set, let display = Self.mainDisplay() else { return }

        _ = set(display, Float(min(max(level, BrightnessMetrics.floor), 1)))
    }

    private static func mainDisplay() -> CGDirectDisplayID? {
        let display = CGMainDisplayID()

        return display == 0 ? nil : display
    }

    private static func symbol<T>(_ name: String) -> T? {
        guard let handle, let address = dlsym(handle, name) else { return nil }

        return unsafeBitCast(address, to: T.self)
    }
}
