import Foundation

/** The 20-byte token HIServices turns into another process's element — pid, zero, `coco`, element id. */
package enum AxRemoteToken {
    package static func data(pid: pid_t, elementId: UInt64) -> Data {
        var token = Data()
        token.append(bytes(of: Int32(pid)))
        token.append(bytes(of: Int32(0)))
        token.append(bytes(of: PrivateFrameworks.axRemoteTokenMagic))
        token.append(bytes(of: elementId))
        return token
    }

    private static func bytes<Value>(of value: Value) -> Data {
        withUnsafeBytes(of: value) { Data($0) }
    }
}
