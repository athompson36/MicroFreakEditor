import Foundation

/// A single modulation route: source → destination with amount (0–1).
struct ModRoute: Equatable, Identifiable {
    let id: UUID
    var sourceId: String
    var destId: String
    var amount: Double

    init(id: UUID = UUID(), sourceId: String, destId: String, amount: Double = 0.5) {
        self.id = id
        self.sourceId = sourceId
        self.destId = destId
        self.amount = min(max(amount, 0), 1)
    }
}

/// Known mod matrix sources (MicroFreak: 5 sources).
enum ModSource: String, CaseIterable, Identifiable {
    case lfo = "LFO"
    case cyclingEnv = "Cycling Env"
    case envelope = "Envelope"
    case velocity = "Velocity"
    case pressure = "Pressure"

    var id: String { rawValue }
}

/// Known mod matrix destinations (MicroFreak: 7, including 3 assignable).
enum ModDestination: String, CaseIterable, Identifiable {
    case cutoff = "Filter Cutoff"
    case resonance = "Resonance"
    case oscTimbre = "Osc Timbre"
    case oscShape = "Osc Shape"
    case assign1 = "Assign 1"
    case assign2 = "Assign 2"
    case assign3 = "Assign 3"

    var id: String { rawValue }
}

/// In-memory mod matrix state. Not sent to hardware until SysEx support exists.
struct ModMatrixModel: Equatable {
    var routes: [ModRoute] = []

    mutating func addRoute(sourceId: String, destId: String, amount: Double = 0.5) {
        routes.append(ModRoute(sourceId: sourceId, destId: destId, amount: amount))
    }

    mutating func removeRoute(id: UUID) {
        routes.removeAll { $0.id == id }
    }

    mutating func setAmount(_ amount: Double, for routeId: UUID) {
        guard let i = routes.firstIndex(where: { $0.id == routeId }) else { return }
        routes[i].amount = min(max(amount, 0), 1)
    }
}
