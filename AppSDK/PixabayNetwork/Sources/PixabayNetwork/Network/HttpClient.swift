import Foundation
import AppCore

public final class HttpClient: HttpClientType {
    @Injected(\.logger) private var logger
    private let baseURL: URL
    private let networkRequest: NetworkRequest
    
    public init(
        baseURL: URL,
        networkRequest: NetworkRequest = NetworkSessionRequest.init(),
    ) {
        self.baseURL = baseURL
        self.networkRequest = networkRequest
    }

    public func send<T: Decodable>(
        _ request: HttpRequest,
        decode type: T.Type
    ) async throws -> (value: T, response: HTTPURLResponse) {
        let (data, response) = try await sendRaw(request)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return (decoded, response)
        } catch {
            logger.error(DecoderMessage.fromError(error))
            throw error
        }
    }

    public func sendRaw(_ request: HttpRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest = try buildURLRequest(from: request)        
        let response = try await networkRequest.request(for: urlRequest)
        guard let httpResponse = response.urlResponse as? HTTPURLResponse else {
            throw NetworkError.badStatus(-1, response.data)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatus(httpResponse.statusCode, response.data)
        }
        return (response.data, httpResponse)
    }

    private func buildURLRequest(from request: HttpRequest) throws -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = request.path
        if request.queryItems.isEmpty == false {
            components?.queryItems = request.queryItems
        }
        guard let url = components?.url else { throw NetworkError.badRequest }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        // set body & headers
        switch request.body {
        case .none:
            break

        case .data(let data, let contentType):
            urlRequest.httpBody = data
            if let contentType {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }

        case .json(let encodable, let encoder):
            let box = AnyEncodable(encodable)
            let data = try encoder.encode(box)
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            logger.network(json: data)

        case .form(let keyValue):
            let formString = keyValue
                .map { key, value in
                    let key = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                    let value = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
                    return "\(key)=\(value)"
                }
                .joined(separator: "&")
            urlRequest.httpBody = formString.data(using: .utf8)
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            logger.network("form:\n\(formString)")
        }

        // merge headers (explicit > existing)
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }

        return urlRequest
    }
}

/// Helper to encode `Encodable` without knowing the concrete type at compile time
private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init(_ wrapped: Encodable) {
        self.encodeFunc = wrapped.encode
    }
    func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
}
