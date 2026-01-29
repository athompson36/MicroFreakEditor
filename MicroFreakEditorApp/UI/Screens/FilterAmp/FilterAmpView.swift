import SwiftUI

struct FilterAmpView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                ParamSectionCard(
                    title: "Filter",
                    paramIds: ParameterRegistry.params(forSection: "Filter").map(\.id),
                    isCompact: app.isCompactMode
                )
                ParamSectionCard(
                    title: "Amp",
                    paramIds: ParameterRegistry.params(forSection: "Amp").map(\.id),
                    isCompact: app.isCompactMode
                )
                ParamSectionCard(
                    title: "Cycling Envelope",
                    paramIds: ParameterRegistry.params(forSection: "Cycling Envelope").map(\.id),
                    isCompact: app.isCompactMode
                )
                ParamSectionCard(
                    title: "Envelope",
                    paramIds: ParameterRegistry.params(forSection: "Envelope").map(\.id),
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
