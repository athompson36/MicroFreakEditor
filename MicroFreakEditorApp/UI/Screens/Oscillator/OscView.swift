import SwiftUI

struct OscView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    private let paramIds = ParameterRegistry.params(forSection: "Oscillator").map(\.id)

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                ParamSectionCard(
                    title: "Oscillator",
                    paramIds: paramIds,
                    isCompact: app.isCompactMode
                )
            }
            .padding(12)
        }
        .background(Theme.cardBackground(scheme).ignoresSafeArea().opacity(0.25))
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Toggle("Compact", isOn: $app.isCompactMode)
                .toggleStyle(.switch)
            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}
