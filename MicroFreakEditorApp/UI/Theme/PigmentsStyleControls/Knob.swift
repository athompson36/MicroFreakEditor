import SwiftUI

/// Placeholder: a vertical slider that behaves like a knob.
/// Later replace with a true rotary control + mod ring overlay.
struct Knob: View {
    let label: String
    let valueText: String
    @Binding var normalizedValue: Double

    var body: some View {
        VStack(spacing: 8) {
            Text(label).font(.subheadline)
            Slider(value: $normalizedValue, in: 0...1)
                .frame(maxWidth: 180)
            Text(valueText).font(.caption).opacity(0.8)
        }
        .padding(12)
    }
}
