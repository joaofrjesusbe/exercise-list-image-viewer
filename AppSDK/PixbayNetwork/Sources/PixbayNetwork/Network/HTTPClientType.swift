import Foundation

public protocol HTTPClientType {
    func send<T: Decodable>(
        _ request: HTTPRequest,
        decode type: T.Type
    ) async throws -> (value: T, response: HTTPURLResponse)

    func sendRaw(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
