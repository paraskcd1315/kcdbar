import Testing

@testable import KcdBarTaskbar

struct AxRemoteTokenTests {
    @Test func theTokenIsTwentyBytesInHIServicesOrder() {
        let token = AxRemoteToken.data(pid: 0x0102_0304, elementId: 0x2A)

        #expect(token.count == 20)
        #expect([UInt8](token) == [4, 3, 2, 1, 0, 0, 0, 0, 0x6F, 0x63, 0x6F, 0x63, 0x2A, 0, 0, 0, 0, 0, 0, 0])
    }
}
