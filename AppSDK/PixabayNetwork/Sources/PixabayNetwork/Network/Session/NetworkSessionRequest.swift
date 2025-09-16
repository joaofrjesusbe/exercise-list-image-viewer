import Foundation
import AppCore

public struct NetworkSessionRequest: NetworkRequest {
    @Injected(\.logger) private var logger
    let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request(for request: URLRequest) async throws -> NetworkResponse {
        let (data, response) = try await session.data(for: request)
        return NetworkResponse(data: data, urlResponse: response)
    }
}
