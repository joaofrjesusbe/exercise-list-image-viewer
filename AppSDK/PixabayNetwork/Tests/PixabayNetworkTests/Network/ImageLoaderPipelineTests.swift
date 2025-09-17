@testable import PixabayNetwork
import Foundation
import Testing

final class ImageLoaderPipelineTests: Sendable {

    @Test
    func image_pipeline_does_not_append_api_key() async throws {
        // Given a cassette-aware factory but with no auth/logging interceptors
        let url = URL(string: "https://example.com/image.jpg?foo=bar")!
        let ok = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let backend = CapturingNetwork(result: .success((Data(), ok)))

        let factory = CassettePipelineFactory(networkMode: .live, mainRequest: backend)
        let pipeline = factory.createCasseteNetwork()

        // When sending a request through the image pipeline
        _ = try await pipeline.request(for: URLRequest(url: url))

        // Then API key should NOT be appended (no APIKeyInterceptor)
        let captured =  try #require(await backend.lastRequest?.url)
        #expect(captured == url)
        #expect(URLComponents(url: captured, resolvingAgainstBaseURL: false)?.queryItems?.contains(where: { $0.name == "key" }) == false)
    }

    @Test
    func image_pipeline_records_and_replays_via_cassette() async throws {
        // Given a record pipeline which writes via cassette
        let url = URL(string: "https://example.com/image.png?q=funny")!
        let ok = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "image/png"])!
        let body = Data("PNGDATA".utf8)

        let recorderBackend = CapturingNetwork(result: .success((body, ok)))
        let recordFactory = CassettePipelineFactory(networkMode: .record, mainRequest: recorderBackend)
        let recordPipeline = recordFactory.createCasseteNetwork()

        // When recording
        let recorded = try await recordPipeline.request(for: URLRequest(url: url))
        #expect(recorded.data == body)

        // And a replay pipeline for the same URL
        let replayFactory = CassettePipelineFactory(networkMode: .replay, mainRequest: CapturingNetwork(result: .failure(NetworkError.general)))
        let replayPipeline = replayFactory.createCasseteNetwork()

        // Then it should replay from disk even though backend would fail
        let replayed = try await replayPipeline.request(for: URLRequest(url: url))
        #expect(replayed.data == body)
    }
}

