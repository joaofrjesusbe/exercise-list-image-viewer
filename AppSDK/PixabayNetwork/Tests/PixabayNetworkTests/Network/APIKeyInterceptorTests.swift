@testable import PixabayNetwork
import Foundation
import Testing

final class APIKeyInterceptorTests: Sendable {
    @Test
    func appends_key_query_item_preserving_existing_items() async throws {
        var req = URLRequest(url: URL(string: "https://example.com/search?q=funny")!)
        let interceptor = APIKeyInterceptor(key: "TEST_KEY")
        let out = try await interceptor.request(&req)
        #expect(out == nil) // should not short-circuit
        let url = try #require(req.url)
        let comps = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let names = (comps.queryItems ?? []).reduce(into: [String:String]()) { $0[$1.name] = $1.value }
        #expect(names["q"] == "funny")
        #expect(names["key"] == "TEST_KEY")
    }
}

