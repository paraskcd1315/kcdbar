import CoreGraphics

enum BarPresetCatalogue {
    static let windows11 = BarPreset(
        name: "windows11",
        edge: .bottom,
        alignment: .centered,
        widthMode: .island,
        attachment: .edgeAttached,
        entryContent: .iconAndTitle,
        entrySizing: .fixed,
        grouping: .perWindow,
        material: .liquidGlass,
        startButton: .leading,
        autoHide: .never,
        displays: .allDisplays,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: 48,
        entrySpacing: KbSpacing.s2,
        contentPadding: KbSpacing.s3,
        cornerRadius: KbRadii.lg,
        showsStatusArea: true
    )

    static let windows10 = BarPreset(
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
        autoHide: .never,
        displays: .allDisplays,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: 40,
        entrySpacing: KbSpacing.s1,
        contentPadding: KbSpacing.s2,
        cornerRadius: KbRadii.none,
        showsStatusArea: true
    )

    static let dock = BarPreset(
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
        autoHide: .never,
        displays: .primaryOnly,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .hide,
        thickness: 64,
        entrySpacing: KbSpacing.s3,
        contentPadding: KbSpacing.s4,
        cornerRadius: KbRadii.xl,
        showsStatusArea: false
    )

    static let minimal = BarPreset(
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
        autoHide: .always,
        displays: .primaryOnly,
        windowScope: .thisDisplay,
        overlap: .pushDisplayFillingWindows,
        dockHandling: .leaveAlone,
        thickness: 36,
        entrySpacing: KbSpacing.s2,
        contentPadding: KbSpacing.s3,
        cornerRadius: KbRadii.lg,
        showsStatusArea: false
    )

    static let all: [BarPreset] = [windows11, windows10, dock, minimal]

    static let `default` = windows11
}
