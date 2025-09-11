import Foundation

public struct NetworkPipeline: NetworkRequest {
    private let network: NetworkRequest
    private let requestInterceptors: [NetworkRequestInterceptor]
    private let responseInterceptors: [NetworkResponseInterceptor]

    public init(
        network: NetworkRequest = NetworkSessionRequest.init(),
        requestInterceptors: [NetworkRequestInterceptor] = [],
        responseInterceptors: [NetworkResponseInterceptor] = []
    ) {
        self.network = network
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }

    public func request(for original: URLRequest) async throws -> NetworkResponse {
        var request = original
        var caught: Error?
        var interceptResponse: NetworkResponse?

        // Request phase: allow short-circuit
        for interceptor in requestInterceptors {
            if let response = try await interceptor.request(&request) {
                interceptResponse = response
                break
            }
        }

        // Network call if nobody short-circuited
        if interceptResponse == nil {
            do {
                interceptResponse = try await network.request(for: request)
            } catch {
                caught = error
            }
        }

        // Response phase (recording, metrics, etc.)
        for interceptor in responseInterceptors {
            await interceptor.adaptResponse(request: request, response: &interceptResponse, error: &caught)
        }

        if let error = caught {
            throw error
        }
        guard let final = interceptResponse else {
            throw NetworkError.badRequest
        }
        return final
    }
}
