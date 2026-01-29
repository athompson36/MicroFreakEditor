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

    private var compactGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Quick Controls")

            HStack(alignment: .top, spacing: 12) {
                paramKnob("mf.filter.cutoff")
                paramKnob("mf.filter.resonance")
                paramKnob("mf.amp.level")
                Spacer()
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }

    private var touchGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Quick Controls")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
                paramKnob("mf.filter.cutoff")
                paramKnob("mf.filter.resonance")
                paramKnob("mf.amp.level")
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }

    @ViewBuilder
    private func paramKnob(_ id: String) -> some View {
        if let p = ParameterRegistry.byId[id] {
            let value = app.microFreak.value(for: id)
            let normalized = p.normalize(value)
            Knob(
                label: p.name,
                valueText: p.format(value),
                normalizedValue: Binding(
                    get: { normalized },
                    set: { newNorm in
                        let newValue = p.denormalize(newNorm)
                        app.microFreak.setValue(newValue, for: id)
                        sendParam(p, value: newValue)
                    }
                )
            )
        } else {
            Text("Missing param: \(id)")
        }
    }

    private func sendParam(_ p: MicroFreakParameter, value: Double) {
        switch p.mapping {
        case .cc(let channel, let number):
            let scaled = UInt8(min(max(Int(round(p.normalize(value) * 127.0)), 0), 127))
            let msg = CCMapper.makeCC(channel: channel, number: number, value: scaled)
            app.midi.send(msg, to: app.deviceSession.selectedDestination)

        case .nrpn(let channel, let parameter):
            let scaled = UInt16(min(max(Int(round(p.normalize(value) * 16383.0)), 0), 16383))
            let msgs = NRPNMapper.makeNRPN(channel: channel, parameter: parameter, value14: scaled)
            for m in msgs {
                app.midi.send(m, to: app.deviceSession.selectedDestination)
            }

        case .none:
            break
        }
    }
}
