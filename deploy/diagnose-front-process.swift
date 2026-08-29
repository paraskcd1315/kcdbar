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
import ApplicationServices

typealias SetFrontProcess = @convention(c) (UnsafePointer<ProcessSerialNumber>, UInt32, UInt32) -> Int32
typealias GetCurrentSpace = @convention(c) (Int32, CFString) -> UInt64
typealias MainConnection = @convention(c) () -> Int32
typealias CopyDisplayForSpace = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
typealias CopySpacesForWindows = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?

guard let id = CommandLine.arguments.dropFirst().first.flatMap({ CGWindowID($0) }) else {
    print("usage: diagnose-front-process.swift <windowId>")
    exit(1)
}
guard let skyLight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_NOW),
      let front = dlsym(skyLight, "_SLPSSetFrontProcessWithOptions"),
      let connection = dlsym(skyLight, "SLSMainConnectionID"),
      let current = dlsym(skyLight, "SLSManagedDisplayGetCurrentSpace"),
      let displayFor = dlsym(skyLight, "SLSCopyManagedDisplayForSpace"),
      let spacesFor = dlsym(skyLight, "SLSCopySpacesForWindows")
else {
    print("SkyLight symbols missing")
    exit(1)
}
let setFront = unsafeBitCast(front, to: SetFrontProcess.self)
let cid = unsafeBitCast(connection, to: MainConnection.self)()

func spaceState() -> String {
    let spaces = unsafeBitCast(spacesFor, to: CopySpacesForWindows.self)(cid, 0x7, [id] as CFArray)?
        .takeRetainedValue() as? [UInt64] ?? []
    guard let space = spaces.first,
          let display = unsafeBitCast(displayFor, to: CopyDisplayForSpace.self)(cid, space)?.takeRetainedValue()
    else {
        return "window \(id) spaces=\(spaces)"
    }
    let now = unsafeBitCast(current, to: GetCurrentSpace.self)(cid, display)
    return "window \(id) space=\(space) current=\(now)"
}

func onScreen() -> Bool {
    let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
    return list.contains { ($0[kCGWindowNumber as String] as? CGWindowID) == id }
}

let info = (CGWindowListCopyWindowInfo([.optionAll], kCGNullWindowID) as? [[String: Any]] ?? [])
    .first { ($0[kCGWindowNumber as String] as? CGWindowID) == id }
guard let pid = info?[kCGWindowOwnerPID as String] as? pid_t else {
    print("window \(id) is not listed by CoreGraphics")
    exit(1)
}
typealias ProcessForPid = @convention(c) (pid_t, UnsafeMutablePointer<ProcessSerialNumber>) -> Int32
guard let services = dlopen("/System/Library/Frameworks/ApplicationServices.framework/ApplicationServices", RTLD_NOW),
      let processForPid = dlsym(services, "GetProcessForPID")
else {
    print("GetProcessForPID missing")
    exit(1)
}
var psn = ProcessSerialNumber()
let found = unsafeBitCast(processForPid, to: ProcessForPid.self)(pid, &psn)
print("before: \(spaceState()) onScreen=\(onScreen()) pid=\(pid) psn=\(found)")
let status = setFront(&psn, id, 0x200)
Thread.sleep(forTimeInterval: 1.5)
print("after front=\(status): \(spaceState()) onScreen=\(onScreen())")
let root = AXUIElementCreateApplication(pid)
var windows: CFTypeRef?
AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &windows)
let titles = (windows as? [AXUIElement] ?? []).compactMap { element -> String? in
    var title: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &title)
    return title as? String
}
print("listed now: \(titles)")
