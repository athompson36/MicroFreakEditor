import SwiftUI

/// Card with a section header and a grid of parameter knobs (compact or touch layout).
struct ParamSectionCard: View {
    let title: String
    let paramIds: [String]
    let isCompact: Bool
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: title)
            if isCompact {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(paramIds, id: \.self) { id in
                        ParamKnobView(paramId: id)
                    }
                    Spacer(minLength: 0)
                }
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: 12)], spacing: 12) {
                    ForEach(paramIds, id: \.self) { id in
                        ParamKnobView(paramId: id)
                    }
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.corner).fill(Theme.cardBackground(scheme)))
        .overlay(RoundedRectangle(cornerRadius: Theme.corner).stroke(Theme.stroke(scheme)))
    }
}
