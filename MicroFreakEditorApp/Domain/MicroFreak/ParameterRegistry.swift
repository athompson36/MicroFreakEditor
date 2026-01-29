import Foundation

// MARK: - MicroFreak CC mapping (midi.guide / Arturia MicroFreak CSV)
enum ParameterRegistry {
    static let all: [MicroFreakParameter] = [
        // General
        .init(
            id: "mf.general.glide",
            name: "Glide",
            section: "General",
            mapping: .cc(channel: 0, number: 5),
            min: 0, max: 1, defaultValue: 0,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Oscillator
        .init(
            id: "mf.osc.type",
            name: "Type",
            section: "Oscillator",
            mapping: .cc(channel: 0, number: 9),
            min: 0, max: 1, defaultValue: 0,
            format: { v in String(format: "%.0f", v * 127) }
        ),
        .init(
            id: "mf.osc.wave",
            name: "Wave",
            section: "Oscillator",
            mapping: .cc(channel: 0, number: 10),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f", v * 127) }
        ),
        .init(
            id: "mf.osc.timbre",
            name: "Timbre",
            section: "Oscillator",
            mapping: .cc(channel: 0, number: 12),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.osc.shape",
            name: "Shape",
            section: "Oscillator",
            mapping: .cc(channel: 0, number: 13),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Filter
        .init(
            id: "mf.filter.cutoff",
            name: "Cutoff",
            section: "Filter",
            mapping: .cc(channel: 0, number: 23),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.filter.resonance",
            name: "Resonance",
            section: "Filter",
            mapping: .cc(channel: 0, number: 83),
            min: 0, max: 1, defaultValue: 0.2,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Amp
        .init(
            id: "mf.amp.level",
            name: "Level",
            section: "Amp",
            mapping: .cc(channel: 0, number: 7),
            min: 0, max: 1, defaultValue: 0.8,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Cycling envelope
        .init(
            id: "mf.cyclingEnv.rise",
            name: "Rise",
            section: "Cycling Envelope",
            mapping: .cc(channel: 0, number: 102),
            min: 0, max: 1, defaultValue: 0.2,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.cyclingEnv.fall",
            name: "Fall",
            section: "Cycling Envelope",
            mapping: .cc(channel: 0, number: 103),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.cyclingEnv.hold",
            name: "Hold",
            section: "Cycling Envelope",
            mapping: .cc(channel: 0, number: 28),
            min: 0, max: 1, defaultValue: 0.3,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.cyclingEnv.amount",
            name: "Amount",
            section: "Cycling Envelope",
            mapping: .cc(channel: 0, number: 24),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Arpeggiator/Sequencer
        .init(
            id: "mf.arpSeq.rateFree",
            name: "Rate (Free)",
            section: "Arp/Seq",
            mapping: .cc(channel: 0, number: 91),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.arpSeq.rateSync",
            name: "Rate (Sync)",
            section: "Arp/Seq",
            mapping: .cc(channel: 0, number: 92),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // LFO
        .init(
            id: "mf.lfo.rateFree",
            name: "Rate (Free)",
            section: "LFO",
            mapping: .cc(channel: 0, number: 93),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.lfo.rateSync",
            name: "Rate (Sync)",
            section: "LFO",
            mapping: .cc(channel: 0, number: 94),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Envelope
        .init(
            id: "mf.env.attack",
            name: "Attack",
            section: "Envelope",
            mapping: .cc(channel: 0, number: 105),
            min: 0, max: 1, defaultValue: 0.2,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.env.decay",
            name: "Decay",
            section: "Envelope",
            mapping: .cc(channel: 0, number: 106),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.env.sustain",
            name: "Sustain",
            section: "Envelope",
            mapping: .cc(channel: 0, number: 29),
            min: 0, max: 1, defaultValue: 0.7,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        .init(
            id: "mf.env.filterAmount",
            name: "Filter Amount",
            section: "Envelope",
            mapping: .cc(channel: 0, number: 26),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
        // Keyboard
        .init(
            id: "mf.keyboard.hold",
            name: "Hold",
            section: "Keyboard",
            mapping: .cc(channel: 0, number: 64),
            min: 0, max: 1, defaultValue: 0,
            format: { v in v >= 0.5 ? "On" : "Off" }
        ),
        .init(
            id: "mf.keyboard.spice",
            name: "Spice",
            section: "Keyboard",
            mapping: .cc(channel: 0, number: 2),
            min: 0, max: 1, defaultValue: 0.5,
            format: { v in String(format: "%.0f%%", v * 100) }
        ),
    ]

    static let byId: [String: MicroFreakParameter] = {
        Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    }()

    /// Lookup param id by CC (channel, number) for incoming MIDI.
    static let ccLookup: [String: String] = {
        var dict: [String: String] = [:]
        for p in all {
            if case .cc(let ch, let cc) = p.mapping {
                dict["\(ch)_\(cc)"] = p.id
            }
        }
        return dict
    }()

    /// Param id for incoming CC, or nil if unknown.
    static func paramId(ccChannel channel: UInt8, ccNumber number: UInt8) -> String? {
        ccLookup["\(channel)_\(number)"]
    }

    /// Parameters for a given section (e.g. "Filter", "Oscillator").
    static func params(forSection section: String) -> [MicroFreakParameter] {
        all.filter { $0.section == section }
    }

    /// Section names used in the UI (order preserved).
    static let sectionOrder: [String] = [
        "General", "Oscillator", "Filter", "Amp",
        "Cycling Envelope", "Arp/Seq", "LFO", "Envelope", "Keyboard"
    ]
}
