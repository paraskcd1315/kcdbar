import Foundation
import ServiceManagement

package struct ServiceManagementLoginItem: LoginItemPort {
    package init() {}

    package var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    package func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            return
        }
    }
}
