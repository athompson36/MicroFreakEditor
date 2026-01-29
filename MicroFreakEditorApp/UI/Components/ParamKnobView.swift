import SwiftUI

/// Reusable parameter control: label, slider (knob-style), value text. Sends MIDI on change.
struct ParamKnobView: View {
    let paramId: String
    @EnvironmentObject private var app: AppState

    var body: some View {
        if let p = ParameterRegistry.byId[paramId] {
            let value = app.microFreak.value(for: paramId)
            let normalized = p.normalize(value)
            Knob(
                label: p.name,
                valueText: p.format(value),
                normalizedValue: Binding(
                    get: { normalized },
                    set: { newNorm in
                        let newValue = p.denormalize(newNorm)
                        app.microFreak.setValue(newValue, for: paramId)
                        sendParam(p, value: newValue)
                    }
                )
            )
        } else {
            Text("Missing: \(paramId)")
                .font(.caption)
                .foregroundStyle(.secondary)
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
