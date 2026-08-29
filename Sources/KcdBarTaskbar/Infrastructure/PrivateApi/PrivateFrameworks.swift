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

/** The private framework paths and dlsym names the bar reaches for. */
package enum PrivateFrameworks {
    package static let applicationServices =
        "/System/Library/Frameworks/ApplicationServices.framework"
        + "/Frameworks/HIServices.framework/Versions/A/HIServices"

    package static let coreDockSendNotification = "CoreDockSendNotification"
    package static let axUIElementGetWindow = "_AXUIElementGetWindow"
    package static let axUIElementCreateWithRemoteToken = "_AXUIElementCreateWithRemoteToken"
    package static let axRemoteTokenMagic: Int32 = 0x636F_636F

    package static let skyLight = "/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight"
    package static let cgsMainConnectionID = "CGSMainConnectionID"
    package static let cgsCopySpacesForWindows = "CGSCopySpacesForWindows"
    package static let cgsCopyManagedDisplayForSpace = "CGSCopyManagedDisplayForSpace"
    package static let cgsManagedDisplayGetCurrentSpace = "CGSManagedDisplayGetCurrentSpace"
    package static let cgsHWCaptureWindowList = "CGSHWCaptureWindowList"
    package static let cgsAllSpacesMask: Int32 = 7
    package static let cgsCaptureIgnoreGlobalClipShape: UInt32 = 1 << 11

    package static let showDesktopNotification = "com.apple.showdesktop.awake"
}
