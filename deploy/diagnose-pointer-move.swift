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

let arguments = CommandLine.arguments.dropFirst().compactMap(Double.init)
guard arguments.count == 2 else {
    print("usage: diagnose-pointer-move.swift <x> <y>   (CoreGraphics coordinates, origin top-left)")
    exit(1)
}
let point = CGPoint(x: arguments[0], y: arguments[1])
CGWarpMouseCursorPosition(point)
guard let move = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) else {
    print("could not build the event")
    exit(1)
}
move.post(tap: .cghidEventTap)
print("pointer moved to \(Int(point.x)),\(Int(point.y))")
