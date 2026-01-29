import SwiftUI

struct DetailHost: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        switch app.selectedSection {
        case .perform: PerformView()
        case .oscillator: PlaceholderView(title: "Oscillator")
        case .filterAmp: PlaceholderView(title: "Filter + Amp")
        case .modMatrix: PlaceholderView(title: "Mod Matrix")
        case .seqArp: PlaceholderView(title: "Seq / Arp")
        case .presets: PlaceholderView(title: "Presets")
        case .settings: MidiSettingsView()
        }
    }
}

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack(spacing: 12) {
            Text(title).font(.title2)
            Text("Coming soon.").opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
