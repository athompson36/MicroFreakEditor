import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isCompactMode: Bool = false
    @Published var selectedSection: AppSection = .perform

    @Published var deviceSession = DeviceSession()
    @Published var microFreak = MicroFreakModel()

    let midi = MidiManager()

    init() {}
}
