import Foundation

enum AppSection: String, CaseIterable, Identifiable {
    case perform = "Perform"
    case oscillator = "Osc"
    case filterAmp = "Filter+Amp"
    case modMatrix = "Mod"
    case seqArp = "Seq/Arp"
    case presets = "Presets"
    case settings = "Settings"

    var id: String { rawValue }
}
