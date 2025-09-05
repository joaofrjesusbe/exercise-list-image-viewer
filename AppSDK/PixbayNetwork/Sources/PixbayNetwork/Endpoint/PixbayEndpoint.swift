import Foundation

enum PixbayEndpoint {
    
    static func search(
        query: String,
        page: Int
    ) -> HTTPRequest {
        return HTTPRequest(
            method: .GET,
            path: "/api",
            queryItems: [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "image_type", value: "photo"),
                URLQueryItem(name: "page", value: page.description)
            ]
        )
    }
    
    static let defaultPageSize: Int = 20
}

extension PixbayEndpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    static var baseUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        return components.url
    }

    static var apiKey: String {
        // add your api key HERE from https://pixabay.com/api/docs/
        "43441041-26aeaa11a049643bc2fba00dc"
    }
}
