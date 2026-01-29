import SwiftUI

struct ModMatrixView: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                modPlaceholder
            }
            .padding(12)
        }
        .background(Theme.cardBackground(scheme).ignoresSafeArea().opacity(0.25))
    }

    private var modPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Mod Matrix")
            Text("Modulation routes, sources, and destinations.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Drag-and-drop modulation creation and mod ring visualization coming in a future update.")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}
