import SwiftUI

struct RootView: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        NavigationSplitView {
            #if os(macOS)
            List(selection: $app.selectedSection) {
                ForEach(AppSection.allCases) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .navigationTitle("MicroFreak")
            #else
            List {
                ForEach(AppSection.allCases) { section in
                    Button {
                        app.selectedSection = section
                    } label: {
                        HStack {
                            Text(section.rawValue)
                            Spacer()
                            if app.selectedSection == section {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
            .navigationTitle("MicroFreak")
            #endif
        } detail: {
            DetailHost()
                .navigationTitle(app.selectedSection.rawValue)
        }
        .onAppear {
            #if os(macOS)
            app.isCompactMode = true
            #else
            app.isCompactMode = false
            #endif

            app.midi.onReceiveMessage = { [weak app] bytes in
                // Parse CC (0xB0): status, data1 = cc number, data2 = value 0–127
                if bytes.count >= 3, (bytes[0] & 0xF0) == 0xB0 {
                    let channel = bytes[0] & 0x0F
                    let ccNumber = bytes[1]
                    let value7 = bytes[2]
                    guard let paramId = ParameterRegistry.paramId(ccChannel: channel, ccNumber: ccNumber),
                          let p = ParameterRegistry.byId[paramId] else { return }
                    let normalized = Double(value7) / 127.0
                    let denormalized = p.denormalize(normalized)
                    DispatchQueue.main.async {
                        guard let app else { return }
                        app.applyIncomingCC(paramId: paramId, value: denormalized)
                    }
                }
            }
        }
    }
}
