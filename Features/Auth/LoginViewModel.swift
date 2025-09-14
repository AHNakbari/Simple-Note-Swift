import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var error: String?
    private let api = APIClient()

    func login() async -> Bool {
        do {
            let ok = try await api.login(username: username, password: password)
            return ok
        } catch {
            self.error = "Login failed. Please try again."
            return false
        }
    }
}