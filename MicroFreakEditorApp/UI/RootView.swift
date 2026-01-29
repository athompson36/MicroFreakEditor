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

            app.midi.onReceiveMessage = { bytes in
                // TODO: parse incoming CC/NRPN later; for now hook point.
                _ = bytes
            }
        }
    }
}
