import Foundation
import AppCore

public struct FailingNetwork: NetworkRequest {
    @Injected(\.logger) public var logger
    
    public init() {}
    
    public func request(for request: URLRequest) async throws -> NetworkResponse {
        logger.error("Record not found")
        throw ReplayError.notFound
    }
}
