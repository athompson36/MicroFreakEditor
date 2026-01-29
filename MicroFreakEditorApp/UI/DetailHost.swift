import SwiftUI

struct DetailHost: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        switch app.selectedSection {
        case .perform: PerformView()
        case .oscillator: OscView()
        case .filterAmp: FilterAmpView()
        case .modMatrix: ModMatrixView()
        case .seqArp: SeqArpView()
        case .presets: PresetsView()
        case .settings: MidiSettingsView()
        }
    }
}
