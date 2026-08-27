import CoreGraphics

/** The rim's rect inside the panel, from the bar's measured frame. */
package enum TaskbarRimPlacement {
    package static func rect(measured: CGRect?, attachment: BarAttachment) -> CGRect? {
        guard let measured, measured.width > 0, measured.height > 0 else { return nil }

        let outset = TaskbarBarLayout.outsetPadding(attachment: attachment)

        return measured.insetBy(dx: outset, dy: outset)
    }
}
