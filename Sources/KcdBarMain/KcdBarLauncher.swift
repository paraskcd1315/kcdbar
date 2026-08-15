import AppKit

/** The app's entry point, called by the bundle's own main. */
@MainActor
public enum KcdBarLauncher {
    public static func run() {
        let application = NSApplication.shared
        let delegate = AppDelegate()
        application.delegate = delegate
        application.run()
    }
}
