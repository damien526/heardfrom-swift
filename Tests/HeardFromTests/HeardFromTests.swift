import Foundation
import Testing
@testable import HeardFrom

@Test func encodesTheRequestTheServerExpects() throws {
    let config = HeardFrom.Config(key: "abc123abc123abc123", endpoint: URL(string: "https://example.com/api/survey")!)
    let req = try HeardFrom.request(for: .appStoreSearch, detail: "  ", config: config)
    #expect(req.httpMethod == "POST")
    let json = try JSONSerialization.jsonObject(with: req.httpBody!) as! [String: Any]
    #expect(json["key"] as? String == "abc123abc123abc123")
    #expect(json["answer"] as? String == "app_store_search")
    #expect(json["detail"] == nil)
}

@Test func trimsAndCapsDetail() throws {
    let config = HeardFrom.Config(key: "k", endpoint: URL(string: "https://example.com")!)
    let req = try HeardFrom.request(for: .other, detail: " " + String(repeating: "x", count: 300), config: config)
    let json = try JSONSerialization.jsonObject(with: req.httpBody!) as! [String: Any]
    #expect((json["detail"] as? String)?.count == 200)
}
