import CoreGraphics
import Testing
@testable import KcdBarTaskbar

@MainActor
struct WindowRegistryRefreshTests {
    private func record(_ id: CGWindowID) -> CgWindowRecord {
        CgWindowRecord(
            windowId: id,
            ownerPid: 500,
            ownerName: "Editor",
            title: "Window \(id)",
            bounds: CGRect(x: 100, y: 100, width: 800, height: 600),
            layer: 0,
            isOnScreen: true,
            zOrder: Int(id)
        )
    }

    private func registry(reading source: any CgWindowSourcePort) -> WindowRegistry {
        WindowRegistry(
            coreGraphicsSource: source,
            accessibilitySource: StubAxWindowSource(),
            applicationsSource: StubRunningApplications(),
            displaySource: StubDisplays(),
            authorization: StubAuthorization()
        )
    }

    @Test func aRefreshReadsOffTheMainActorAndAppliesOnIt() async {
        let registry = registry(reading: StubCgWindowSource(records: [record(1), record(2)]))

        await registry.refresh()

        #expect(registry.lastScanCounts.coreGraphicsRecords == 2)
        #expect(registry.hasAccessibility)
        #expect(registry.displays.count == 1)
    }

    @Test func theOlderOfTwoOverlappingReadsDoesNotOverwriteTheNewer() async {
        let gate = GatedCgWindowSource(first: [record(1)], later: [record(1), record(2)])
        let registry = registry(reading: gate)

        let older = Task { await registry.refresh() }
        while !gate.isBlocked {
            await Task.yield()
        }
        await registry.refresh()

        #expect(registry.lastScanCounts.coreGraphicsRecords == 2)

        gate.release()
        await older.value

        #expect(registry.lastScanCounts.coreGraphicsRecords == 2)
    }

    @Test func aPidThatJustLostItsWindowsIsStillAsked() {
        let asked = WindowRegistry.pidsWorthAsking(in: [], previousOwners: [500])

        #expect(asked == [500])
    }
}
