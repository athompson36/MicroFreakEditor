import Foundation

struct MicroFreakModel: Equatable {
    var values: [String: Double] = {
        var dict: [String: Double] = [:]
        for p in ParameterRegistry.all {
            dict[p.id] = p.defaultValue
        }
        return dict
    }()

    init() {}

    init(values: [String: Double]) {
        self.values = values
    }

    mutating func setValue(_ value: Double, for paramId: String) {
        guard let p = ParameterRegistry.byId[paramId] else { return }
        values[paramId] = p.clamp(value)
    }

    func value(for paramId: String) -> Double {
        values[paramId] ?? ParameterRegistry.byId[paramId]?.defaultValue ?? 0
    }
}
