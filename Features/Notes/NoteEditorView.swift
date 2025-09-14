import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: NoteDTO
    var onSave: (NoteDTO) -> Void

    init(note: NoteDTO, onSave: @escaping (NoteDTO) -> Void) {
        _draft = State(initialValue: note)
        self.onSave = onSave
    }

    var body: some View {
        Form {
            TextField("Title", text: $draft.title)
            TextEditor(text: $draft.content)
                .frame(minHeight: 200)
        }
        .navigationTitle("Edit note")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSave(draft)
                    dismiss()
                }
            }
        }
    }
}