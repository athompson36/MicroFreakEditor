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
                stepGridCard
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

    private var stepGridCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Step Grid (App Mode)")
            Text("Tap steps to toggle. Internal clock and MIDI sync in a future update.")
                .font(.caption)
                .foregroundStyle(.tertiary)
            StepGridView()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}

// MARK: - Step grid (16 steps, one lane)

private struct StepGridView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    private let columns = Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 16)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(Array(app.stepPattern.steps.enumerated()), id: \.offset) { index, step in
                StepCell(
                    stepNumber: index + 1,
                    isOn: step.gate,
                    onTap: { app.stepPattern.toggleStep(at: index) }
                )
            }
        }
    }
}

private struct StepCell: View {
    let stepNumber: Int
    let isOn: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: onTap) {
            Text("\(stepNumber)")
                .font(.system(.caption2, design: .monospaced))
                .frame(minWidth: 28, minHeight: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isOn ? Theme.stroke(scheme) : Theme.cardBackground(scheme).opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Theme.stroke(scheme), lineWidth: isOn ? 0 : 1)
                )
                .foregroundStyle(isOn ? Color.primary : .secondary)
        }
        .buttonStyle(.plain)
    }
}
