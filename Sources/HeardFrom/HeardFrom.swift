import Foundation

/// Asks new users where they heard about the app and reports the answer to Dailyreel.
/// Call `configure` once at launch, then show `HeardFromView` once, after onboarding.
public enum HeardFrom {
    public enum Answer: String, CaseIterable, Sendable, Codable {
        case tiktok, instagram, appStoreSearch = "app_store_search", friend, youtube, other

        public var title: String {
            switch self {
            case .tiktok: "TikTok"
            case .instagram: "Instagram"
            case .appStoreSearch: "App Store search"
            case .friend: "A friend"
            case .youtube: "YouTube"
            case .other: "Somewhere else"
            }
        }
    }

    struct Config: Sendable {
        let key: String
        let endpoint: URL
    }

    nonisolated(unsafe) static var config: Config?
    static let answeredKey = "heardfrom.answered"

    public static func configure(key: String, endpoint: URL = URL(string: "https://www.dailyreel.app/api/survey")!) {
        config = Config(key: key, endpoint: endpoint)
    }

    /// True once the user has answered (or skipped) on this device.
    public static var hasAnswered: Bool {
        UserDefaults.standard.bool(forKey: answeredKey)
    }

    public static func markAnswered() {
        UserDefaults.standard.set(true, forKey: answeredKey)
    }

    struct Body: Encodable { let key: String; let answer: String; let detail: String? }

    static func request(for answer: Answer, detail: String?, config: Config) throws -> URLRequest {
        var req = URLRequest(url: config.endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let trimmed = detail?.trimmingCharacters(in: .whitespacesAndNewlines)
        req.httpBody = try JSONEncoder().encode(Body(key: config.key, answer: answer.rawValue, detail: trimmed?.isEmpty == false ? String(trimmed!.prefix(200)) : nil))
        return req
    }

    /// Sends the answer. Failures are silent: the survey must never block the user.
    public static func submit(_ answer: Answer, detail: String? = nil, session: URLSession = .shared) async {
        markAnswered()
        guard let config, let req = try? request(for: answer, detail: detail, config: config) else { return }
        _ = try? await session.data(for: req)
    }
}
