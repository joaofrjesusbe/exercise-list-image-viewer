@testable import PixabayNetwork
import Foundation
import Testing

final class CassetteFSTests: @unchecked Sendable {

    private func tempDir() -> URL {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("CassetteFSTests-\(UUID().uuidString)", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    @Test
    func record_and_load_roundtrip_ignores_stripped_query_items() throws {
        let root = tempDir()
        let rootPath = root.path

        // Given a request with sensitive key which should be stripped
        var comps = URLComponents(string: "https://example.com/api")!
        comps.queryItems = [
            URLQueryItem(name: "q", value: "Funny"),
            URLQueryItem(name: "key", value: "SHOULD_NOT_MATTER")
        ]
        let url = comps.url!
        let request = URLRequest(url: url)

        // And a response to record
        let body = Data("{\"items\":1}".utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!

        // When recording
        let saved = CassetteFileSystem.record(rootPath: rootPath, request: request, response: response, data: body, stripNames: ["key"])!
        #expect(FileManager.default.fileExists(atPath: saved))

        // Then loading with a different key value still finds the cassette
        var comps2 = URLComponents(string: "https://example.com/api")!
        comps2.queryItems = [
            URLQueryItem(name: "q", value: "Funny"),
            URLQueryItem(name: "key", value: "DIFFERENT")
        ]
        let url2 = comps2.url!
        let req2 = URLRequest(url: url2)

        let (loadedData, loadedResp) = try CassetteFileSystem.load(searchRootPaths: [rootPath], request: req2, stripNames: ["key"])
        #expect(loadedData == body)
        #expect((loadedResp as? HTTPURLResponse)?.statusCode == 200)
    }

    @Test
    func body_file_helpers_pick_json() throws {
        // Content type JSON path
        #expect(CassetteFileSystem.bodyFileName(contentType: "application/json", isJSON: true) == "response.json")
        // Heuristic JSON path
        #expect(CassetteFileSystem.bodyLooksJSON(contentType: nil, data: Data(" { } ".utf8)))
    }
}

