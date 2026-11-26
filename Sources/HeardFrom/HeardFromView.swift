import SwiftUI

/// A one-question screen. `onDone` is called after an answer or a skip.
public struct HeardFromView: View {
    private let onDone: (HeardFrom.Answer?) -> Void
    @State private var other = ""
    @State private var showingOther = false

    public init(onDone: @escaping (HeardFrom.Answer?) -> Void) {
        self.onDone = onDone
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How did you hear about us?")
                .font(.title2.bold())
                .padding(.bottom, 8)
            ForEach(HeardFrom.Answer.allCases, id: \.self) { answer in
                Button {
                    if answer == .other { showingOther = true } else { finish(answer, detail: nil) }
                } label: {
                    Text(answer.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            if showingOther {
                TextField("Where?", text: $other)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit { finish(.other, detail: other) }
                Button("Continue") { finish(.other, detail: other) }
                    .buttonStyle(.borderedProminent)
            }
            Button("Skip") {
                HeardFrom.markAnswered()
                onDone(nil)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .padding(24)
    }

    private func finish(_ answer: HeardFrom.Answer, detail: String?) {
        Task { await HeardFrom.submit(answer, detail: detail) }
        onDone(answer)
    }
}
