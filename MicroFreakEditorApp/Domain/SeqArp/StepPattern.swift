import Foundation

/// Single step in a sequencer lane: gate on/off and velocity (0–1).
struct StepState: Equatable {
    var gate: Bool
    var velocity: Double

    init(gate: Bool = false, velocity: Double = 0.8) {
        self.gate = gate
        self.velocity = min(max(velocity, 0), 1)
    }
}

/// One lane of steps (e.g. 16 steps). Used for step grid UI; MIDI/clock sync later.
struct StepPattern: Equatable {
    static let defaultStepCount = 16

    var steps: [StepState]

    init(stepCount: Int = StepPattern.defaultStepCount) {
        self.steps = (0..<stepCount).map { _ in StepState() }
    }

    mutating func toggleStep(at index: Int) {
        guard steps.indices.contains(index) else { return }
        steps[index].gate.toggle()
    }

    mutating func setStep(at index: Int, gate: Bool, velocity: Double = 0.8) {
        guard steps.indices.contains(index) else { return }
        steps[index] = StepState(gate: gate, velocity: velocity)
    }
}
