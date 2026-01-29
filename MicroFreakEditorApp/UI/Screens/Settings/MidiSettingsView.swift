import SwiftUI
import CoreMIDI

struct MidiSettingsView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 12) {
            GroupBox("MIDI Ports") {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Found \(app.midi.sources.count) sources, \(app.midi.destinations.count) destinations")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Refresh") {
                            app.midi.refreshEndpoints()
                        }
                        .buttonStyle(.bordered)
                    }

                    // Connection status
                    if let dest = app.deviceSession.selectedDestination, dest != 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Sending to: \(app.midi.name(for: dest))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 6).fill(.green.opacity(0.15)))
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text("Select a Destination below to send MIDI to the synth.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 6).fill(.orange.opacity(0.12)))
                    }
                    
                    Picker("Source", selection: Binding(
                        get: { app.deviceSession.selectedSource ?? 0 },
                        set: { newValue in
                            app.deviceSession.selectedSource = (newValue == 0 ? nil : newValue)
                            app.midi.connect(
                                source: app.deviceSession.selectedSource,
                                destination: app.deviceSession.selectedDestination
                            )
                        }
                    )) {
                        Text("None").tag(MIDIEndpointRef(0))
                        ForEach(app.midi.sources, id: \.self) { ep in
                            Text(endpointName(ep)).tag(ep)
                        }
                    }

                    Picker("Destination", selection: Binding(
                        get: { app.deviceSession.selectedDestination ?? 0 },
                        set: { newValue in
                            app.deviceSession.selectedDestination = (newValue == 0 ? nil : newValue)
                            app.midi.connect(
                                source: app.deviceSession.selectedSource,
                                destination: app.deviceSession.selectedDestination
                            )
                        }
                    )) {
                        Text("None").tag(MIDIEndpointRef(0))
                        ForEach(app.midi.destinations, id: \.self) { ep in
                            Text(endpointName(ep)).tag(ep)
                        }
                    }

                    Button("Connect") {
                        app.midi.connect(
                            source: app.deviceSession.selectedSource,
                            destination: app.deviceSession.selectedDestination
                        )
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 6)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
            .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))

            Spacer()
        }
        .padding(12)
    }

    private func endpointName(_ endpoint: MIDIEndpointRef) -> String {
        var name: Unmanaged<CFString>?
        MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &name)
        let nameStr = (name?.takeRetainedValue() as String?) ?? "Unknown"
        
        // Also try to get manufacturer/model info for better identification
        var manufacturer: Unmanaged<CFString>?
        MIDIObjectGetStringProperty(endpoint, kMIDIPropertyManufacturer, &manufacturer)
        if let mfr = manufacturer?.takeRetainedValue() as String?, !mfr.isEmpty {
            return "\(nameStr) (\(mfr))"
        }
        
        return nameStr
    }
}
