import Foundation
import AppCore

public final class HTTPClient: HTTPClientType {
    @Injected(\.logger) private var logger
    private let baseURL: URL
    private let session: URLSession
    private let recorder: NetworkRecorder?

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        recorder: NetworkRecorder? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.recorder = recorder
    }

    public func send<T: Decodable>(
        _ request: HTTPRequest,
        decode type: T.Type
    ) async throws -> (value: T, response: HTTPURLResponse) {
        let (data, response) = try await sendRaw(request)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return (decoded, response)
        } catch {
            logger.error(error.localizedDescription)
            throw error
        }
    }

    public func sendRaw(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest = try buildURLRequest(from: request)
        logger.network("\(request.method.rawValue) url:\n\(urlRequest.url?.absoluteString ?? "unknown")")
        
        let (data, urlResponse) = try await session.data(for: urlRequest)

        guard let http = urlResponse as? HTTPURLResponse else {
            throw NetworkError.badStatus(-1, data)
        }

        if (200..<300).contains(http.statusCode) == false {
            // still record the error payload for debugging
            await recorder?.record(request: urlRequest, response: http, data: data)
            throw NetworkError.badStatus(http.statusCode, data)
        }

        await recorder?.record(request: urlRequest, response: http, data: data)
        return (data, http)
    }

    private func buildURLRequest(from request: HTTPRequest) throws -> URLRequest {
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
