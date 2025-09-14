import Foundation

enum FileStore {
    private static let fileName = "notes.json"

    private static func fileURL() -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    static func loadNotes() -> [NoteDTO] {
        let url = fileURL()
        if !FileManager.default.fileExists(atPath: url.path) {
            let seed = [NoteDTO.sample]
            saveNotes(seed)
            return seed
        }
        do {
            let data = try Data(contentsOf: url)
            let notes = try JSONDecoder().decode([NoteDTO].self, from: data)
            return notes
        } catch {
            print("Load notes error: \(error)")
            return [NoteDTO.sample]
        }
    }

    static func saveNotes(_ notes: [NoteDTO]) {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL(), options: .atomic)
        } catch {
            print("Save notes error: \(error)")
        }
    }
}