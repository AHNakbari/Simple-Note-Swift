import SwiftUI

struct NotesListView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject var vm = NotesViewModel()

    var body: some View {
        List {
            ForEach(vm.filtered) { note in
                NavigationLink(value: note) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title).font(.headline)
                        Text(note.content).lineLimit(2).foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { idx in Task { await vm.delete(at: idx) } }
        }
        .navigationDestination(for: NoteDTO.self) { note in
            NoteEditorView(note: note) { updated in
                Task { await vm.update(note: updated) }
            }
        }
        .navigationTitle("SimpleNote")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let username = Keychain.get(Keychain.usernameKey) ?? "demo"
                    let uid = Int64(Keychain.get(Keychain.userIdKey) ?? "1") ?? 1
                    Task { await vm.addNote(username: username, userId: uid) }
                } label: { Image(systemName: "plus") }
            }
        }
        .task { await vm.load() }
        .searchable(text: $vm.query, placement: .navigationBarDrawer(displayMode: .automatic))
    }
}