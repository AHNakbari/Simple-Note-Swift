import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    let api = APIClient()

    init() {
        isAuthenticated = Keychain.get(Keychain.accessTokenKey) != nil
    }

    func logout() {
        Keychain.delete(Keychain.accessTokenKey)
        Keychain.delete(Keychain.refreshTokenKey)
        Keychain.delete(Keychain.usernameKey)
        Keychain.delete(Keychain.userIdKey)
        isAuthenticated = false
    }
}