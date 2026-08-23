import Foundation

package enum SessionsFormatting {
    package static func share(_ context: SessionContext) -> String {
        context.share.formatted(.percent.precision(.fractionLength(0)))
    }

    package static func tokens(_ count: Int) -> String {
        count.formatted(.number.notation(.compactName))
    }

    package static func quiet(_ seconds: TimeInterval) -> String {
        Duration.seconds(max(Int(seconds), 0)).formatted(
            .units(allowed: [.hours, .minutes], width: .narrow)
        )
    }
}
