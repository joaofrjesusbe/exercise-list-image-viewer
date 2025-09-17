import Foundation

public typealias NetworkResponse = (data: Data, urlResponse: URLResponse)

public protocol NetworkRequest: Sendable {
    /// Load a recorded response that matches the given URLRequest.
    func request(for request: URLRequest) async throws -> NetworkResponse
}

public protocol NetworkRequestInterceptor: Sendable {
    /// Load a recorded response that matches the given URLRequest.
    func request(_ request: inout URLRequest) async throws -> NetworkResponse?
}

public protocol NetworkResponseInterceptor: Sendable {
    func adaptResponse(request: URLRequest, response: inout NetworkResponse?, error: inout Error?) async
}
