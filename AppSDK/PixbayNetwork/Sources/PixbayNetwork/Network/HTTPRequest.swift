import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

public struct HTTPRequest {
    public var method: HTTPMethod
    public var path: String
    public var queryItems: [URLQueryItem] = []
    public var headers: [String: String] = [:]
    public var body: HTTPBody? = nil

    public init(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: HTTPBody? = nil
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}

public enum HTTPBody {
    case data(Data, contentType: String?)
    case json(Encodable, encoder: JSONEncoder = JSONEncoder())
    case form([String: String]) // application/x-www-form-urlencoded
}
