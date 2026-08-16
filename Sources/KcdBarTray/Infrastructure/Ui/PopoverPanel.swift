import AppKit

/** A borderless popover panel that may take key status when a field inside it is opened. */
package final class PopoverPanel: NSPanel {
    package override var canBecomeKey: Bool { true }
}
