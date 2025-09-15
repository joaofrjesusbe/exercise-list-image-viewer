import Foundation

public protocol HttpClientType {
    func send<T: Decodable>(
        _ request: HttpRequest,
        decode type: T.Type
    ) async throws -> (value: T, response: HTTPURLResponse)

    func sendRaw(_ request: HttpRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
