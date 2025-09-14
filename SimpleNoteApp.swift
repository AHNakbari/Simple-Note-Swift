import SwiftUI

@main
struct SimpleNoteApp: App {
    @StateObject private var session = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            if session.isAuthenticated {
                MainView()
                    .environmentObject(session)
            } else {
                NavigationStack {
                    LoginView()
                }
                .environmentObject(session)
            }
        }
    }
}