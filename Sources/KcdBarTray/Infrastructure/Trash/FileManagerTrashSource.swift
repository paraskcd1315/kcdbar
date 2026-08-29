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
import SwiftUI

/** Reads the user's trash and watches it for change. */
@MainActor
package final class FileManagerTrashSource: TrashPort {
    private var watcher: DispatchSourceFileSystemObject?
    private var descriptor: Int32 = -1
    private var emptySound: NSSound?

    package init() {}

    package func state() -> TrashState {
        guard let url = Self.trashUrl else { return .empty }

        let items = try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        return TrashState(isEmpty: items?.isEmpty ?? true)
    }

    package func icon(isEmpty: Bool) -> Image? {
        let name = isEmpty ? NSImage.trashEmptyName : NSImage.trashFullName
        guard let image = NSImage(named: name) else { return nil }

        return Image(nsImage: image)
    }

    package func open() {
        guard let url = Self.trashUrl else { return }

        NSWorkspace.shared.open(url)
    }

    package func empty() {
        guard let url = Self.trashUrl,
              let items = try? FileManager.default.contentsOfDirectory(
                  at: url,
                  includingPropertiesForKeys: nil,
                  options: []
              ),
              !items.isEmpty
        else {
            return
        }
        for item in items {
            try? FileManager.default.removeItem(at: item)
        }
        playEmptySound()
    }

    private func playEmptySound() {
        let wanted = UserDefaults.standard.object(forKey: TrashSounds.interfaceEffectsKey) as? Bool
        guard wanted ?? true else { return }

        emptySound = NSSound(contentsOfFile: TrashSounds.empty, byReference: true)
        emptySound?.play()
    }

    package func watch(_ onChange: @escaping () -> Void) {
        stopWatching()
        guard let url = Self.trashUrl else { return }

        descriptor = Darwin.open(url.path, O_EVTONLY)
        guard descriptor >= 0 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: [.write, .delete, .rename],
            queue: .main
        )
        source.setEventHandler { MainActor.assumeIsolated(onChange) }
        source.resume()
        watcher = source
    }

    package func stopWatching() {
        watcher?.cancel()
        watcher = nil
        if descriptor >= 0 {
            Darwin.close(descriptor)
            descriptor = -1
        }
    }

    private static var trashUrl: URL? {
        FileManager.default.urls(for: .trashDirectory, in: .userDomainMask).first
    }
}
