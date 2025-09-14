import Foundation

@MainActor
final class NotesViewModel: ObservableObject {
    @Published var notes: [NoteDTO] = []
    @Published var query: String = ""

    private let api = APIClient()
    private var lastUpdate: Date?

    func load() async {
        // Try sync (if backend set), then load local
        do {
            let updates = try await api.getUpdates(since: lastUpdate)
            if !updates.isEmpty {
                merge(updates)
            }
            lastUpdate = Date()
        } catch {
            // offline or not configured — ignore
        }
        notes = FileStore.loadNotes().sorted { $0.lastEdited > $1.lastEdited }
    }

    private func merge(_ server: [NoteDTO]) {
        var local = FileStore.loadNotes()
        var map = Dictionary(uniqueKeysWithValues: local.map { ($0.id, $0) })
        for s in server { map[s.id] = s }
        let merged = Array(map.values)
        FileStore.saveNotes(merged)
    }

    func addNote(username: String, userId: Int64) async {
        var items = FileStore.loadNotes()
        let newId = (items.map { $0.id }.max() ?? 0) + 1
        let note = NoteDTO(id: newId, title: "New note", content: "", lastEdited: Date(), isSynced: false, username: username, isPinned: false, color: "orange", userId: userId)
        items.insert(note, at: 0)
        FileStore.saveNotes(items)
        notes = items
        try? await api.create(note)
    }

    func update(note: NoteDTO) async {
        var items = FileStore.loadNotes()
        if let idx = items.firstIndex(where: { $0.id == note.id }) {
            var n = note
            n.lastEdited = Date()
            items[idx] = n
            FileStore.saveNotes(items)
            notes = items
            try? await api.update(n)
        }
    }

    func delete(at offsets: IndexSet) async {
        var items = FileStore.loadNotes()
        let ids = offsets.map { notes[$0].id }
        items.removeAll { ids.contains($0.id) }
        FileStore.saveNotes(items)
        notes = items
        for id in ids { try? await api.delete(id: id) }
    }

    var filtered: [NoteDTO] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return notes }
        let q = query.lowercased()
        return notes.filter { $0.title.lowercased().contains(q) || $0.content.lowercased().contains(q) }
    }
}