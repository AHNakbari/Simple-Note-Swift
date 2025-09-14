import Foundation

extension ISO8601DateFormatter {
    static let precise: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.timeZone = .gmt
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
}