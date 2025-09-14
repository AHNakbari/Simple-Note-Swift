import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationStack { NotesListView() }
                .tabItem { Label("Notes", systemImage: "note.text") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}