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

import AppKit
import CoreGraphics
import ScreenCaptureKit

typealias SetWindowAlpha = @convention(c) (Int32, CGWindowID, Float) -> Int32
typealias MainConnection = @convention(c) () -> Int32

func write(_ image: CGImage, to path: String) {
    let rep = NSBitmapImageRep(cgImage: image)
    let data = rep.representation(using: .png, properties: [:])
    try? data?.write(to: URL(fileURLWithPath: path))
}

func probeAlpha(on windowId: CGWindowID) {
    let skyLight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_NOW)
    guard let mainSymbol = dlsym(skyLight, "CGSMainConnectionID"),
          let alphaSymbol = dlsym(skyLight, "CGSSetWindowAlpha")
    else {
        print("alpha symbols=missing")
        return
    }
    let connection = unsafeBitCast(mainSymbol, to: MainConnection.self)()
    let status = unsafeBitCast(alphaSymbol, to: SetWindowAlpha.self)(connection, windowId, 1.0)
    print("alpha window=\(windowId) status=\(status)")
}

let output = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "/tmp"
let semaphore = DispatchSemaphore(value: 0)

Task {
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        let desktopLevel = content.windows.filter { $0.windowLayer < 0 }
        for window in desktopLevel {
            print("desktop layer=\(window.windowLayer) owner=\(window.owningApplication?.bundleIdentifier ?? "-") title=\(window.title ?? "-") frame=\(window.frame)")
        }
        let target = content.windows.first {
            $0.windowLayer == 0 && $0.isOnScreen && $0.frame.width > 200 && $0.frame.height > 200
                && $0.owningApplication?.bundleIdentifier != Bundle.main.bundleIdentifier
        }
        print("target=\(target.map { "\($0.windowID) \($0.owningApplication?.bundleIdentifier ?? "-") \($0.frame)" } ?? "none")")
        for display in content.displays {
            let configuration = SCStreamConfiguration()
            configuration.width = display.width * 2
            configuration.height = display.height * 2
            configuration.showsCursor = false
            let onDisplay = desktopLevel.filter { $0.frame.intersects(display.frame) }
            let start = Date()
            let desktop = try await SCScreenshotManager.captureImage(
                contentFilter: SCContentFilter(display: display, including: onDisplay),
                configuration: configuration
            )
            print("display=\(display.displayID) desktop ms=\(Int(Date().timeIntervalSince(start) * 1000)) size=\(desktop.width)x\(desktop.height)")
            write(desktop, to: "\(output)/peek-desktop-\(display.displayID).png")
            if let target, target.frame.intersects(display.frame) {
                let start = Date()
                let peek = try await SCScreenshotManager.captureImage(
                    contentFilter: SCContentFilter(display: display, including: onDisplay + [target]),
                    configuration: configuration
                )
                print("display=\(display.displayID) window ms=\(Int(Date().timeIntervalSince(start) * 1000))")
                write(peek, to: "\(output)/peek-window-\(display.displayID).png")
            }
        }
        if let target { probeAlpha(on: target.windowID) }
    } catch {
        print("error=\(error)")
    }
    semaphore.signal()
}
semaphore.wait()
