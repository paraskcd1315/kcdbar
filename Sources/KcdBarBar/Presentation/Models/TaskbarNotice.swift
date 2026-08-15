package enum TaskbarNotice: Equatable {
    case accessibilityMissing

    package var symbolName: String {
        "lock.trianglebadge.exclamationmark"
    }

    package var messageKey: String {
        "taskbar.notice.accessibility"
    }

    package var actionKey: String {
        "taskbar.notice.grant"
    }
}
