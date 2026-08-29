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

private typealias MainConnectionFn = @convention(c) () -> Int32
private typealias CaptureWindowListFn = @convention(c) (Int32, UnsafePointer<UInt32>, Int32, UInt32) -> Unmanaged<CFArray>?

/** Captures one window through SkyLight, on any Space, scaled to fit; a missing symbol answers nil. */
package struct SkyLightWindowCapture {
    package init() {}

    private static let calls: (MainConnectionFn, CaptureWindowListFn)? = {
        guard let handle = dlopen(PrivateFrameworks.skyLight, RTLD_LAZY),
              let connection = dlsym(handle, PrivateFrameworks.cgsMainConnectionID),
              let capture = dlsym(handle, PrivateFrameworks.cgsHWCaptureWindowList)
        else {
            return nil
        }
        return (
            unsafeBitCast(connection, to: MainConnectionFn.self),
            unsafeBitCast(capture, to: CaptureWindowListFn.self)
        )
    }()

    package func capture(windowId: CGWindowID, fitting size: CGSize) -> CGImage? {
        guard let (connection, capture) = Self.calls else { return nil }
        var list: [UInt32] = [windowId]
        let images = capture(connection(), &list, 1, PrivateFrameworks.cgsCaptureIgnoreGlobalClipShape)?
            .takeRetainedValue() as? [CGImage] ?? []
        guard let image = images.first else { return nil }

        return scaled(image, toFit: size)
    }

    private func scaled(_ image: CGImage, toFit size: CGSize) -> CGImage? {
        let width = CGFloat(image.width)
        let height = CGFloat(image.height)
        guard width > 0, height > 0 else { return nil }
        let scale = min(size.width / width, size.height / height, 1)
        let target = CGSize(width: (width * scale).rounded(), height: (height * scale).rounded())
        guard let context = CGContext(
            data: nil,
            width: Int(target.width),
            height: Int(target.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        ) else {
            return nil
        }
        context.interpolationQuality = .high
        context.draw(image, in: CGRect(origin: .zero, size: target))

        return context.makeImage()
    }
}
