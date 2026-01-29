import SwiftUI

struct ModMatrixView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    @State private var showAddRoute = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                routesCard
            }
            .padding(12)
        }
        .background(Theme.cardBackground(scheme).ignoresSafeArea().opacity(0.25))
        .sheet(isPresented: $showAddRoute) {
            AddModRouteSheet(onAdd: { sourceId, destId, amount in
                app.modMatrix.addRoute(sourceId: sourceId, destId: destId, amount: amount)
            })
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Toggle("Compact", isOn: $app.isCompactMode)
                .toggleStyle(.switch)
            Spacer()
            Button {
                showAddRoute = true
            } label: {
                Label("Add route", systemImage: "plus.circle.fill")
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }

    private var routesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Modulation routes")
            Text("Source → Destination with amount. Hardware sync via SysEx in a future update.")
                .font(.caption)
                .foregroundStyle(.tertiary)

            if app.modMatrix.routes.isEmpty {
                Text("No routes. Tap \"Add route\" to add one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(app.modMatrix.routes) { route in
                    ModRouteRow(
                        route: route,
                        onAmountChange: { app.modMatrix.setAmount($0, for: route.id) },
                        onDelete: { app.modMatrix.removeRoute(id: route.id) }
                    )
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}

// MARK: - Row

private struct ModRouteRow: View {
    let route: ModRoute
    let onAmountChange: (Double) -> Void
    let onDelete: () -> Void
    @Environment(\.colorScheme) private var scheme

    private var sourceName: String {
        ModSource.allCases.first(where: { $0.id == route.sourceId })?.id ?? route.sourceId
    }

    private var destName: String {
        ModDestination.allCases.first(where: { $0.id == route.destId })?.id ?? route.destId
    }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(sourceName)
                    .font(.subheadline.weight(.medium))
                Text("→ \(destName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(minWidth: 100, alignment: .leading)

            Slider(value: Binding(
                get: { route.amount },
                set: { onAmountChange($0) }
            ), in: 0...1)
            .tint(Theme.stroke(scheme))

            Text(String(format: "%.0f%%", route.amount * 100))
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 36, alignment: .trailing)

            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.body)
            }
            .buttonStyle(.borderless)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.cardBackground(scheme).opacity(0.6)))
    }
}

// MARK: - Add route sheet

private struct AddModRouteSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String, Double) -> Void

    @State private var sourceId: String = ModSource.lfo.id
    @State private var destId: String = ModDestination.cutoff.id
    @State private var amount: Double = 0.5

    var body: some View {
        NavigationStack {
            Form {
                Picker("Source", selection: $sourceId) {
                    ForEach(ModSource.allCases) { s in
                        Text(s.id).tag(s.id)
                    }
                }
                Picker("Destination", selection: $destId) {
                    ForEach(ModDestination.allCases) { d in
                        Text(d.id).tag(d.id)
                    }
                }
                HStack {
                    Text("Amount")
                    Slider(value: $amount, in: 0...1)
                    Text(String(format: "%.0f%%", amount * 100))
                        .font(.caption.monospacedDigit())
                        .frame(width: 36)
                }
            }
            .navigationTitle("Add modulation route")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(sourceId, destId, amount)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ModMatrixView()
        .environmentObject(AppState())
}
