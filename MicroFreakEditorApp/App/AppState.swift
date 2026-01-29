import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isCompactMode: Bool = false
    @Published var selectedSection: AppSection = .perform

    @Published var deviceSession = DeviceSession()
    @Published var microFreak = MicroFreakModel()
    @Published var modMatrix = ModMatrixModel()
    @Published var stepPattern = StepPattern()

    let midi = MidiManager()

    init() {}

    /// Apply incoming CC from hardware so UI reflects synth state.
    func applyIncomingCC(paramId: String, value: Double) {
        microFreak.setValue(value, for: paramId)
    }

    /// Send current parameter state to the selected MIDI destination (e.g. after loading a preset).
    func sendCurrentStateToSynth() {
        guard let dest = deviceSession.selectedDestination, dest != 0 else { return }
        for p in ParameterRegistry.all {
            switch p.mapping {
            case .cc(let channel, let number):
                let value = microFreak.value(for: p.id)
                let scaled = UInt8(min(max(Int(round(p.normalize(value) * 127.0)), 0), 127))
                let msg = CCMapper.makeCC(channel: channel, number: number, value: scaled)
                midi.send(msg, to: dest)
            case .nrpn(let channel, let parameter):
                let value = microFreak.value(for: p.id)
                let scaled = UInt16(min(max(Int(round(p.normalize(value) * 16383.0)), 0), 16383))
                let msgs = NRPNMapper.makeNRPN(channel: channel, parameter: parameter, value14: scaled)
                for m in msgs { midi.send(m, to: dest) }
            case .none:
                break
            }
        }
    }
}
