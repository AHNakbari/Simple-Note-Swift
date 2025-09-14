import Foundation

enum APIError: Error { case invalidResponse, badStatus(Int), notConfigured }

struct APIClient {
    private func request(_ path: String, method: String = "GET", body: Data? = nil, auth: Bool = true) async throws -> (Data, HTTPURLResponse) {
        guard let base = Config.baseURL else { throw APIError.notConfigured }
        var url = base.appendingPathComponent(path)
        var req = URLRequest(url: url)
        req.httpMethod = method
        if let body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        if auth, let token = Keychain.get(Keychain.accessTokenKey) {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
        if !(200...299).contains(http.statusCode) { throw APIError.badStatus(http.statusCode) }
        return (data, http)
    }

    // MARK: Auth
    @discardableResult
    func login(username: String, password: String) async throws -> Bool {
        if Config.baseURL == nil {
            // Offline demo: accept any credentials
            Keychain.set("offline_access", for: Keychain.accessTokenKey)
            Keychain.set("offline_refresh", for: Keychain.refreshTokenKey)
            Keychain.set(username, for: Keychain.usernameKey)
            Keychain.set("1", for: Keychain.userIdKey)
            return true
        }
        let payload = ["username": username, "password": password]
        let data = try JSONSerialization.data(withJSONObject: payload)
        let (res, _) = try await request("/api/auth/token/", method: "POST", body: data, auth: false)
        let tokens = try JSONDecoder().decode(TokenResponse.self, from: res)
        Keychain.set(tokens.access, for: Keychain.accessTokenKey)
        Keychain.set(tokens.refresh, for: Keychain.refreshTokenKey)
        let user = try await userInfo()
        Keychain.set(user.username, for: Keychain.usernameKey)
        Keychain.set(String(user.id), for: Keychain.userIdKey)
        return true
    }

    func register(username: String, password: String, sex: String?) async throws -> Bool {
        if Config.baseURL == nil { return true }
        let payload: [String: Any] = ["username": username, "password": password]
        let data = try JSONSerialization.data(withJSONObject: payload)
        _ = try await request("/api/auth/register/", method: "POST", body: data, auth: false)
        return true
    }

    func userInfo() async throws -> UserInfoResponse {
        if Config.baseURL == nil { return .init(id: 1, username: Keychain.get(Keychain.usernameKey) ?? "demo") }
        let (data, _) = try await request("/api/auth/userinfo/")
        return try JSONDecoder().decode(UserInfoResponse.self, from: data)
    }

    // MARK: Notes
    func getUpdates(since: Date?) async throws -> [NoteDTO] {
        if Config.baseURL == nil { return [] }
        var path = "/api/notes/get_update"
        if let since {
            let iso = ISO8601DateFormatter.precise.string(from: since)
            path += "?time=\(iso)"
        }
        let (data, _) = try await request(path)
        return try JSONDecoder().decode([NoteDTO].self, from: data)
    }

    func create(_ note: NoteDTO) async throws {
        if Config.baseURL == nil { return }
        let data = try JSONEncoder().encode(note)
        _ = try await request("/api/notes/", method: "POST", body: data)
    }

    func update(_ note: NoteDTO) async throws {
        if Config.baseURL == nil { return }
        let data = try JSONEncoder().encode(note)
        _ = try await request("/api/notes/\(note.id)/", method: "PUT", body: data)
    }

    func delete(id: Int64) async throws {
        if Config.baseURL == nil { return }
        _ = try await request("/api/notes/\(id)/", method: "DELETE")
    }
}