import SwiftUI

struct PresetsView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme
    @State private var presetNames: [String] = PresetStore.listPresetNames()
    @State private var saveName: String = ""
    @State private var showSaveField: Bool = false
    @State private var loadError: String?
    @State private var saveError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                saveSection
                presetList
            }
            .padding(12)
        }
        .background(Theme.cardBackground(scheme).ignoresSafeArea().opacity(0.25))
        .onAppear { presetNames = PresetStore.listPresetNames() }
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

    private var saveSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Save Current")
            if showSaveField {
                HStack(spacing: 8) {
                    TextField("Preset name", text: $saveName)
                        .textFieldStyle(.roundedBorder)
                    Button("Save") {
                        saveCurrent()
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Cancel") {
                        showSaveField = false
                        saveName = ""
                        saveError = nil
                    }
                    .buttonStyle(.bordered)
                }
                if let err = saveError {
                    Text(err).font(.caption).foregroundStyle(.red)
                }
            } else {
                Button("Save current state as preset…") {
                    showSaveField = true
                    saveError = nil
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }

    private var presetList: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Presets")
            if presetNames.isEmpty {
                Text("No presets saved. Save current state to create one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(12)
            } else {
                ForEach(presetNames, id: \.self) { name in
                    HStack(spacing: 12) {
                        Button(name) {
                            loadPreset(name)
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                        Button(role: .destructive) {
                            deletePreset(name)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(8)
                }
            }
            if let err = loadError {
                Text(err).font(.caption).foregroundStyle(.red)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }

    private func saveCurrent() {
        let name = saveName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            saveError = "Enter a name."
            return
        }
        do {
            try PresetStore.save(app.microFreak, name: name)
            presetNames = PresetStore.listPresetNames()
            showSaveField = false
            saveName = ""
            saveError = nil
        } catch {
            saveError = error.localizedDescription
        }
    }

    private func loadPreset(_ name: String) {
        loadError = nil
        do {
            if let model = try PresetStore.load(name: name) {
                app.microFreak = model
                // Optionally send all params to synth (full dump) — for v1 we just update UI
            } else {
                loadError = "Preset not found."
            }
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func deletePreset(_ name: String) {
        loadError = nil
        do {
            try PresetStore.delete(name: name)
            presetNames = PresetStore.listPresetNames()
        } catch {
            loadError = error.localizedDescription
        }
    }
}
