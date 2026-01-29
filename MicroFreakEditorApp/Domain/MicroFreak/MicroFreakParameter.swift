import Foundation

enum MidiMapping: Equatable {
    case cc(channel: UInt8, number: UInt8)
    /// Standard NRPN via CC 99/98 (param MSB/LSB) + CC 6/38 (value MSB/LSB)
    case nrpn(channel: UInt8, parameter: UInt16)
    case none
}

struct MicroFreakParameter: Identifiable {
    let id: String
    let name: String
    let section: String
    let mapping: MidiMapping

    let min: Double
    let max: Double
    let defaultValue: Double

    var format: (Double) -> String = { v in String(format: "%.3f", v) }

    func clamp(_ value: Double) -> Double {
        Swift.min(Swift.max(value, min), max)
    }

    func normalize(_ value: Double) -> Double {
        let v = clamp(value)
        if max == min { return 0 }
        return (v - min) / (max - min)
    }

    func denormalize(_ normalized: Double) -> Double {
        let n = Swift.min(Swift.max(normalized, 0), 1)
        return min + (max - min) * n
    }
}
