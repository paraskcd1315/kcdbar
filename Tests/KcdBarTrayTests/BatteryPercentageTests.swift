import Testing
@testable import KcdBarTray

struct BatteryPercentageTests {
    @Test func aFullBatteryReadsAHundred() {
        #expect(BatteryPercentage.of(capacity: 4200, maximum: 4200) == 100)
    }

    @Test func aHalfBatteryRounds() {
        #expect(BatteryPercentage.of(capacity: 2101, maximum: 4200) == 50)
    }

    @Test func aMissingMaximumCannotDivide() {
        #expect(BatteryPercentage.of(capacity: 100, maximum: 0) == 0)
    }
}
