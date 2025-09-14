import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var sex: String = "Man" // or "Woman"
    @Published var message: String?

    private let api = APIClient()

    func register() async -> Bool {
        guard !username.isEmpty, password == confirmPassword else {
            message = "Please fill all fields and match passwords."
            return false
        }
        do {
            let ok = try await api.register(username: username, password: password, sex: sex)
            message = ok ? "Registered. You can login now." : "Registration failed."
            return ok
        } catch {
            message = "Registration failed."
            return false
        }
    }
}