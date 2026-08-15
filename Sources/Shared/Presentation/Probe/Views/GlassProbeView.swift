import SwiftUI

struct GlassProbeView: View {
    let surface: GlassProbeSurface

    var body: some View {
        GlassEffectContainer {
            HStack(spacing: KbSpacing.s5) {
                GlassProbeCapsule(label: surface.labelKey)
                GlassProbeSwatch()
            }
        }
        .padding(KbSpacing.s5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
