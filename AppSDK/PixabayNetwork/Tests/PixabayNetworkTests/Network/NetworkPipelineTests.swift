@testable import PixabayNetwork
import Foundation
import Testing

final class NetworkPipelineTests: Sendable {

    @Test
    func short_circuits_when_request_interceptor_returns_response_and_still_calls_response_interceptors() async throws {
        // A canned response
        let data = Data("OK".utf8)
        let resp = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let canned: NetworkResponse = (data, resp)

        let backend = MockNetwork(result: .failure(NetworkError.general)) // should not be called
        let resInterceptor = MockResInterceptor()
        let reqInterceptor = MockReqInterceptor { _ in canned }

        let pipeline = NetworkPipeline(mainRequest: backend, requestInterceptors: [reqInterceptor], responseInterceptors: [resInterceptor])

        let request = URLRequest(url: URL(string: "https://example.com")!)
        let out = try await pipeline.request(for: request)
        #expect(out.data == data)
        #expect(await resInterceptor.didAdapt)
        #expect(await backend.lastRequest == nil) // backend not called
    }

    @Test
    func propagates_error_when_backend_fails_and_calls_response_interceptors() async throws {
        enum E: Error { case boom }
        let backend = MockNetwork(result: .failure(E.boom))
        let resInterceptor = MockResInterceptor()
        let pipeline = NetworkPipeline(mainRequest: backend, requestInterceptors: [], responseInterceptors: [resInterceptor])

        await #expect(throws: E.boom) {
            _ = try await pipeline.request(for: URLRequest(url: URL(string: "https://example.com")!))
        }
        #expect(await resInterceptor.didAdapt)
    }
}
