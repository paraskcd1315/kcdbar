import CoreGraphics
import KcdBarDesignSystem

package enum BarPresetCatalogue {
    package static let windows11 = BarPreset(
        name: "windows11",
        edge: .bottom,
        alignment: .centered,
        widthMode: .island,
        attachment: .edgeAttached,
        entryContent: .iconOnly,
        entrySizing: .fixed,
        grouping: .perWindow,
        material: .liquidGlass,
        startButton: .leading,
        startMark: .windows11,
        autoHide: .never,
        displays: .allDisplays,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: BarStrutMetrics.dockStrutHeight,
        entrySpacing: KbSpacing.s2,
        contentPadding: KbSpacing.s3,
        cornerRadius: KbRadii.lg,
        entryCornerRadius: KbRadii.md,
        iconSize: BarEntryMetrics.iconSize,
        showsStatusArea: true,
        showsDesktopButton: true
    )

    package static let windows10 = BarPreset(
        name: "windows10",
        edge: .bottom,
        alignment: .leading,
        widthMode: .fullEdge,
        attachment: .edgeAttached,
        entryContent: .iconAndTitle,
        entrySizing: .fixed,
        grouping: .perWindow,
        material: .vibrancy,
        startButton: .leading,
        startMark: .windows10,
        autoHide: .never,
        displays: .allDisplays,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: 40,
        entrySpacing: KbSpacing.s1,
        contentPadding: KbSpacing.s2,
        cornerRadius: KbRadii.none,
        entryCornerRadius: KbRadii.none,
        iconSize: 24,
        showsStatusArea: true,
        showsDesktopButton: true
    )

    package static let dock = BarPreset(
        name: "dock",
        edge: .bottom,
        alignment: .centered,
        widthMode: .island,
        attachment: .floating,
        entryContent: .iconOnly,
        entrySizing: .magnifying,
        grouping: .perApplication,
        material: .liquidGlass,
        startButton: .hidden,
        startMark: .apple,
        autoHide: .never,
        displays: .primaryOnly,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: 64,
        entrySpacing: KbSpacing.s3,
        contentPadding: KbSpacing.s4,
        cornerRadius: KbRadii.xl,
        entryCornerRadius: KbRadii.lg,
        iconSize: 48,
        showsStatusArea: false,
        showsDesktopButton: false
    )

    package static let minimal = BarPreset(
        name: "minimal",
        edge: .top,
        alignment: .centered,
        widthMode: .island,
        attachment: .floating,
        entryContent: .iconOnly,
        entrySizing: .fixed,
        grouping: .perWindow,
        material: .liquidGlass,
        startButton: .hidden,
        startMark: .bars,
        autoHide: .always,
        displays: .primaryOnly,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .leaveAlone,
        thickness: 36,
        entrySpacing: KbSpacing.s2,
        contentPadding: KbSpacing.s3,
        cornerRadius: KbRadii.lg,
        entryCornerRadius: KbRadii.sm,
        iconSize: 22,
        showsStatusArea: false,
        showsDesktopButton: false
    )

    package static let all: [BarPreset] = [windows11, windows10, dock, minimal]

    package static let `default` = windows11
}
