import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                HStack {
                    Text("Username")
                    Spacer()
                    Text(Keychain.get(Keychain.usernameKey) ?? "demo").foregroundStyle(.secondary)
                }
            }

            Section(header: Text("Server"), footer: Text("Set Config.baseURL in code to enable your backend. Currently: \(Config.baseURL?.absoluteString ?? "offline").")) {
                if let url = Config.baseURL {
                    Text(url.absoluteString)
                } else {
                    Text("Offline mode (local JSON store)").foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) { session.logout() } label: {
                    Text("Logout")
                }
            }
        }
        .navigationTitle("Settings")
    }
}