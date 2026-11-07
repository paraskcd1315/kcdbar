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

import CoreMedia
import IOSurface
import ScreenCaptureKit

/** Hands each complete frame of a peek stream to the main actor. */
package final class WindowPeekStreamOutput: NSObject, SCStreamOutput {
    private let onFrame: @MainActor @Sendable (IOSurfaceRef) -> Void

    package init(onFrame: @escaping @MainActor @Sendable (IOSurfaceRef) -> Void) {
        self.onFrame = onFrame
    }

    package func stream(
        _ stream: SCStream,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
        of type: SCStreamOutputType
    ) {
        guard type == .screen,
              sampleBuffer.isValid,
              isComplete(sampleBuffer),
              let pixelBuffer = sampleBuffer.imageBuffer,
              let surface = CVPixelBufferGetIOSurface(pixelBuffer)?.takeUnretainedValue()
        else {
            return
        }
        nonisolated(unsafe) let frame = surface
        let handler = onFrame
        MainActor.assumeIsolated {
            handler(frame)
        }
    }

    private func isComplete(_ sampleBuffer: CMSampleBuffer) -> Bool {
        guard let attachments = CMSampleBufferGetSampleAttachmentsArray(
            sampleBuffer,
            createIfNecessary: false
        ) as? [[SCStreamFrameInfo: Any]],
            let raw = attachments.first?[.status] as? Int
        else {
            return false
        }

        return SCFrameStatus(rawValue: raw) == .complete
    }
}
