import Foundation

struct TokenResponse: Codable {
    let access: String
    let refresh: String
}

struct UserInfoResponse: Codable {
    let id: Int64
    let username: String
}