import Foundation

struct APIKeyInterceptor: NetworkRequestInterceptor {
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func request(_ request: inout URLRequest) async throws -> NetworkResponse? {
        if let url = request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            var components = components
            var items = components.queryItems ?? []
            items.append(URLQueryItem(name: "key", value: key))
            components.queryItems = items
            request.url = components.url
        }
        return nil
    }
}
