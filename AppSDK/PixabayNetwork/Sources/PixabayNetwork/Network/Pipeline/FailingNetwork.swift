import Foundation

public struct FailingNetwork: NetworkRequest {
    public init() {}
    
    public func request(for request: URLRequest) async throws -> NetworkResponse {
        throw ReplayError.notFound
    }
}
