import Foundation

public protocol NetworkRecorder {
    func record(request: URLRequest, response: HTTPURLResponse, data: Data) async
}

public struct NoopRecorder: NetworkRecorder {
    public init() {}
    public func record(request: URLRequest, response: HTTPURLResponse, data: Data) async {}
}
