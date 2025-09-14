import Foundation

struct NoteDTO: Codable, Identifiable, Equatable {
    var id: Int64
    var title: String
    var content: String
    var lastEdited: Date
    var isSynced: Bool
    var username: String
    var isPinned: Bool
    var color: String
    var userId: Int64
}

extension NoteDTO {
    static var sample: NoteDTO {
        .init(
            id: 1,
            title: "Welcome to SimpleNote iOS",
            content: "This is a sample note saved locally. Tap + to add, or tap a note to edit.",
            lastEdited: Date(),
            isSynced: false,
            username: "demo",
            isPinned: false,
            color: "orange",
            userId: 1
        )
    }
}