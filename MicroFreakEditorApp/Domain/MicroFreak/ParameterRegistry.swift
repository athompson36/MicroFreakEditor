import Foundation

enum ParameterRegistry {
    static let all: [MicroFreakParameter] = [
        .init(
            id: "mf.filter.cutoff",
            name: "Cutoff",
            section: "Filter",
            mapping: .cc(channel: 0, number: 23), // MicroFreak: Filter Cutoff (midi.guide)
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.filter.resonance",
            name: "Resonance",
            section: "Filter",
            mapping: .cc(channel: 0, number: 83), // MicroFreak: Filter Resonance (midi.guide)
            min: 0, max: 1, defaultValue: 0.2,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.amp.level",
            name: "Amp Level",
            section: "Amp",
            mapping: .cc(channel: 0, number: 7), // Standard MIDI volume; MicroFreak may respond
            min: 0, max: 1, defaultValue: 0.8,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
    ]

    static let byId: [String: MicroFreakParameter] = {
        Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    }()
}
