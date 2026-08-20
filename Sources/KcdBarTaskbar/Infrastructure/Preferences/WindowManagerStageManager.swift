import Foundation

package struct WindowManagerStageManager: StageManagerPort {
    package init() {}

    package var isEnabled: Bool {
        let held = CFPreferencesCopyValue(
            StageManagerKeys.globallyEnabled as CFString,
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )

        return (held as? Bool) ?? (held as? NSNumber)?.boolValue ?? false
    }

    package func setEnabled(_ enabled: Bool) {
        CFPreferencesSetValue(
            StageManagerKeys.globallyEnabled as CFString,
            enabled as CFBoolean,
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        CFPreferencesSynchronize(
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        DistributedNotificationCenter.default().postNotificationName(
            Notification.Name(StageManagerKeys.changeNotification),
            object: nil,
            userInfo: nil,
            deliverImmediately: true
        )
    }
}
