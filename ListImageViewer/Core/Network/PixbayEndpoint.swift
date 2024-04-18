import Foundation

struct PixbayEndpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension PixbayEndpoint {
    
    static func search(
        query: String,
        page: Int
    ) -> PixbayEndpoint {
        return PixbayEndpoint(
            path: "/api",
            queryItems: [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "image_type", value: "photo"),
                URLQueryItem(name: "page", value: page.description)
            ]
        )
    }
}

extension PixbayEndpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    static var apiKey: String {
        // add your api key HERE from https://pixabay.com/api/docs/
        ""
    }
}
