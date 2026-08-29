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

typealias CreateWithRemoteToken = @convention(c) (CFData) -> Unmanaged<AXUIElement>?
typealias GetWindowOfElement = @convention(c) (AXUIElement, UnsafeMutablePointer<CGWindowID>) -> AXError
typealias SetFrontProcess = @convention(c) (UnsafeMutablePointer<ProcessSerialNumber>, UInt32, UInt32) -> Int32
typealias PostEventRecord = @convention(c) (UnsafeMutablePointer<ProcessSerialNumber>, UnsafeMutablePointer<UInt8>) -> Int32
typealias ProcessForPid = @convention(c) (pid_t, UnsafeMutablePointer<ProcessSerialNumber>) -> Int32
typealias GetCurrentSpace = @convention(c) (Int32, CFString) -> UInt64
typealias MainConnection = @convention(c) () -> Int32
typealias CopyDisplayForSpace = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
typealias CopySpacesForWindows = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?

let arguments = Array(CommandLine.arguments.dropFirst())
guard let id = arguments.first.flatMap({ CGWindowID($0) }) else {
    print("usage: diagnose-remote-ax.swift <windowId> [front] [key] [raise]")
    exit(1)
}
let stages = Set(arguments.dropFirst())
guard let hiServices = dlopen("/System/Library/Frameworks/ApplicationServices.framework/Frameworks/HIServices.framework/HIServices", RTLD_NOW),
      let createSymbol = dlsym(hiServices, "_AXUIElementCreateWithRemoteToken"),
      let windowOfSymbol = dlsym(hiServices, "_AXUIElementGetWindow"),
      let processSymbol = dlsym(hiServices, "GetProcessForPID"),
      let skyLight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_NOW),
      let frontSymbol = dlsym(skyLight, "_SLPSSetFrontProcessWithOptions"),
      let postSymbol = dlsym(skyLight, "SLPSPostEventRecordTo"),
      let connection = dlsym(skyLight, "SLSMainConnectionID"),
      let current = dlsym(skyLight, "SLSManagedDisplayGetCurrentSpace"),
      let displayFor = dlsym(skyLight, "SLSCopyManagedDisplayForSpace"),
      let spacesFor = dlsym(skyLight, "SLSCopySpacesForWindows")
else {
    print("a symbol is missing: \(String(cString: dlerror()))")
    exit(1)
}
let cid = unsafeBitCast(connection, to: MainConnection.self)()
let create = unsafeBitCast(createSymbol, to: CreateWithRemoteToken.self)
let windowOf = unsafeBitCast(windowOfSymbol, to: GetWindowOfElement.self)

func spaceState() -> String {
    let spaces = unsafeBitCast(spacesFor, to: CopySpacesForWindows.self)(cid, 0x7, [id] as CFArray)?
        .takeRetainedValue() as? [UInt64] ?? []
    guard let space = spaces.first,
          let display = unsafeBitCast(displayFor, to: CopyDisplayForSpace.self)(cid, space)?.takeRetainedValue()
    else {
        return "spaces=\(spaces)"
    }
    return "space=\(space) current=\(unsafeBitCast(current, to: GetCurrentSpace.self)(cid, display))"
}

func onScreen() -> Bool {
    let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
    return list.contains { ($0[kCGWindowNumber as String] as? CGWindowID) == id }
}

func attribute(_ element: AXUIElement, _ name: String) -> String {
    var value: CFTypeRef?
    let status = AXUIElementCopyAttributeValue(element, name as CFString, &value)
    return status == .success ? (value as? String ?? "?") : "error \(status.rawValue)"
}

func elementBySweep(pid: pid_t, budget: TimeInterval) -> (AXUIElement, UInt64)? {
    var token = Data(count: 20)
    token.replaceSubrange(0..<4, with: withUnsafeBytes(of: Int32(pid)) { Data($0) })
    token.replaceSubrange(4..<8, with: withUnsafeBytes(of: Int32(0)) { Data($0) })
    token.replaceSubrange(8..<12, with: withUnsafeBytes(of: Int32(0x636f636f)) { Data($0) })
    let started = Date()
    var elementId: UInt64 = 0
    while Date().timeIntervalSince(started) < budget {
        token.replaceSubrange(12..<20, with: withUnsafeBytes(of: elementId) { Data($0) })
        if let candidate = create(token as CFData)?.takeRetainedValue() {
            var found: CGWindowID = 0
            if windowOf(candidate, &found) == .success, found == id,
               attribute(candidate, kAXRoleAttribute) == kAXWindowRole {
                return (candidate, elementId)
            }
        }
        elementId += 1
    }
    print("sweep reached id \(elementId) in \(budget)s without a match")
    return nil
}

let info = (CGWindowListCopyWindowInfo([.optionAll], kCGNullWindowID) as? [[String: Any]] ?? [])
    .first { ($0[kCGWindowNumber as String] as? CGWindowID) == id }
guard let pid = info?[kCGWindowOwnerPID as String] as? pid_t else {
    print("window \(id) is not listed by CoreGraphics")
    exit(1)
}
print("before: \(spaceState()) onScreen=\(onScreen())")
let sweepStarted = Date()
let found = elementBySweep(pid: pid, budget: 3)
if let (element, elementId) = found {
    print("element id=\(elementId) after \(Int(Date().timeIntervalSince(sweepStarted) * 1000))ms title=\(attribute(element, kAXTitleAttribute)) subrole=\(attribute(element, kAXSubroleAttribute))")
}
var psn = ProcessSerialNumber()
unsafeBitCast(processSymbol, to: ProcessForPid.self)(pid, &psn)
if stages.contains("front") {
    print("front=\(unsafeBitCast(frontSymbol, to: SetFrontProcess.self)(&psn, id, 0x200))")
}
if stages.contains("key") {
    var wid = id
    var point = CGPoint(x: 300_000, y: 300_000)
    var bytes = [UInt8](repeating: 0, count: 0x100)
    bytes[0x04] = 0xf8
    bytes[0x3a] = 0x10
    memcpy(&bytes[0x3c], &wid, MemoryLayout<CGWindowID>.size)
    memcpy(&bytes[0x20], &point, MemoryLayout<CGPoint>.size)
    bytes[0x08] = 0x01
    print("key=\(unsafeBitCast(postSymbol, to: PostEventRecord.self)(&psn, &bytes))")
}
if stages.contains("raise"), let (element, _) = found {
    print("raise=\(AXUIElementPerformAction(element, kAXRaiseAction as CFString).rawValue)")
}
Thread.sleep(forTimeInterval: 1.5)
print("after: \(spaceState()) onScreen=\(onScreen())")
