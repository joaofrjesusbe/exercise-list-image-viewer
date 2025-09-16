import Foundation
import AppCore

public struct NetworkLoggerInterceptor: NetworkRequestInterceptor {
    @Injected(\.logger) private var logger
    
    public func request(_ request: inout URLRequest) async throws -> NetworkResponse? {
        logger.network("\(request.httpMethod ?? "GET") url:\n\(request.url?.absoluteString ?? "unknown")")
        return nil
    }
}
