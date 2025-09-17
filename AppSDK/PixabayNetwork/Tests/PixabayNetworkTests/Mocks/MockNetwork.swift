@testable import PixabayNetwork
import Foundation
import Testing

// MARK: - Mocks
actor MockNetwork: NetworkRequest {
    var lastRequest: URLRequest?
    var result: Result<NetworkResponse, Error>
    init(result: Result<NetworkResponse, Error>) { self.result = result }
    func request(for request: URLRequest) async throws -> NetworkResponse {
        lastRequest = request
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}

actor MockReqInterceptor: NetworkRequestInterceptor {
    var handler: (inout URLRequest) async throws -> NetworkResponse?
    init(_ handler: @escaping (inout URLRequest) async throws -> NetworkResponse?) { self.handler = handler }
    func request(_ request: inout URLRequest) async throws -> NetworkResponse? { try await handler(&request) }
}

actor MockResInterceptor: NetworkResponseInterceptor {
    var didAdapt = false
    func adaptResponse(request: URLRequest, response: inout NetworkResponse?, error: inout Error?) async {
        didAdapt = true
    }
}

actor CapturingNetwork: NetworkRequest {
    var lastRequest: URLRequest?
    var result: Result<NetworkResponse, Error>
    init(result: Result<NetworkResponse, Error>) { self.result = result }
    func request(for request: URLRequest) async throws -> NetworkResponse {
        lastRequest = request
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
