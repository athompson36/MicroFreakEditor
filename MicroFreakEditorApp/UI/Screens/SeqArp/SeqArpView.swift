import SwiftUI

struct SeqArpView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                ParamSectionCard(
                    title: "Arp / Seq",
                    paramIds: ParameterRegistry.params(forSection: "Arp/Seq").map(\.id),
                    isCompact: app.isCompactMode
                )
                ParamSectionCard(
                    title: "LFO",
                    paramIds: ParameterRegistry.params(forSection: "LFO").map(\.id),
                    isCompact: app.isCompactMode
                )
                stepGridPlaceholder
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

    private var stepGridPlaceholder: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Step Grid (App Mode)")
            Text("Step sequencer and pattern editor coming in a future update.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}
