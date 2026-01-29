import SwiftUI

struct PerformView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar

                if app.isCompactMode {
                    compactGrid
                } else {
                    touchGrid
                }
            }
            .padding(12)
        }
        .background(Theme.cardBackground(scheme).ignoresSafeArea().opacity(0.25))
    }

    private var topBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Toggle("Compact", isOn: $app.isCompactMode)
                    .toggleStyle(.switch)

                Spacer()

                // MIDI connection status
                if let dest = app.deviceSession.selectedDestination, dest != 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                        Text(app.midi.name(for: dest))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.orange)
                            .font(.caption)
                        Text("No MIDI output")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Button("Refresh MIDI") {
                    app.midi.refreshEndpoints()
                }
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
            .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
        }
    }

    private static let performParamIds = [
        "mf.general.glide",
        "mf.filter.cutoff",
        "mf.filter.resonance",
        "mf.amp.level",
        "mf.keyboard.spice",
    ]

    private var compactGrid: some View {
        ParamSectionCard(
            title: "Quick Controls",
            paramIds: Self.performParamIds,
            isCompact: true
        )
    }

    private var touchGrid: some View {
        ParamSectionCard(
            title: "Quick Controls",
            paramIds: Self.performParamIds,
            isCompact: false
        )
    }
}
