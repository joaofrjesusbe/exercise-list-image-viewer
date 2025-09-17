@testable import PixabayNetwork
import Foundation
import Testing

// Reuse MockNetwork from NetworkPipelineTests via test target module scope

private struct DummyDecodable: Codable, Equatable { let name: String }

final class HttpClientTests: Sendable {

    @Test
    func build_url_and_query_items_and_headers() async throws {
        // Arrange
        let base = URL(string: "https://api.example.com")!
        let expectedURL = URL(string: "https://api.example.com/v1/search?q=cat&page=2")!

        // Backend returns 200 to satisfy sendRaw
        let ok = HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let backend = MockNetwork(result: .success((Data(), ok)))
        let client = HttpClient(baseURL: base, networkRequest: backend)

        let request = HttpRequest(
            method: .GET,
            path: "/v1/search",
            queryItems: [URLQueryItem(name: "q", value: "cat"), URLQueryItem(name: "page", value: "2")],
            headers: ["X-Test": "1"],
            body: nil
        )

        // Act
        _ = try await client.sendRaw(request)

        // Assert
        let captured = try #require(await backend.lastRequest)
        #expect(captured.url == expectedURL)
        #expect(captured.value(forHTTPHeaderField: "X-Test") == "1")
        #expect(captured.httpMethod == "GET")
    }

    @Test
    func json_body_sets_content_type_and_encodes() async throws {
        // Arrange
        let base = URL(string: "https://api.example.com")!
        let url = URL(string: "https://api.example.com/v1/create")!
        let ok = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let backend = MockNetwork(result: .success((Data(), ok)))
        let client = HttpClient(baseURL: base, networkRequest: backend)

        struct Payload: Encodable { let a: Int; let b: String }
        let payload = Payload(a: 10, b: "x")

        let request = HttpRequest(method: .POST, path: "/v1/create", body: .json(payload))

        // Act
        _ = try await client.sendRaw(request)

        // Assert
        let captured = try #require(await backend.lastRequest)
        #expect(captured.httpMethod == "POST")
        #expect(captured.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try #require(captured.httpBody)
        let obj = try JSONSerialization.jsonObject(with: body) as? [String: Any]
        #expect(obj?["a"] as? Int == 10)
        #expect(obj?["b"] as? String == "x")
    }

    @Test
    func send_decodes_success_and_errors_on_status_code_or_bad_json() async throws {
        let base = URL(string: "https://api.example.com")!

        // Success decode
        do {
            let url = URL(string: "https://api.example.com/x")!
            let ok = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(DummyDecodable(name: "ok"))
            let backend = MockNetwork(result: .success((data, ok)))
            let client = HttpClient(baseURL: base, networkRequest: backend)
            let (value, _) = try await client.send(HttpRequest(method: .GET, path: "/x"), decode: DummyDecodable.self)
            #expect(value == DummyDecodable(name: "ok"))
        }

        // Bad status code
        do {
            let url = URL(string: "https://api.example.com/x")!
            let ko = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let backend = MockNetwork(result: .success((Data(), ko)))
            let client = HttpClient(baseURL: base, networkRequest: backend)
            if let err: NetworkError = await #expect(throws: NetworkError.self, performing: {
                _ = try await client.send(HttpRequest(method: .GET, path: "/x"), decode: DummyDecodable.self)
            }) {
                switch err {
                case .badStatus(let code, _): #expect(code == 404)
                default: Issue.record("Unexpected error: \(String(describing: err))")
                }
            }
        }

        // Bad JSON
        do {
            let url = URL(string: "https://api.example.com/x")!
            let ok = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let backend = MockNetwork(result: .success((Data("not json".utf8), ok)))
            let client = HttpClient(baseURL: base, networkRequest: backend)
            await #expect(throws: DecodingError.self) {
                _ = try await client.send(HttpRequest(method: .GET, path: "/x"), decode: DummyDecodable.self)
            }
        }
    }
}
