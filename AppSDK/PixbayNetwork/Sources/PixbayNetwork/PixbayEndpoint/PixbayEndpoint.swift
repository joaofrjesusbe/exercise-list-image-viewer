import Foundation

enum PixbayEndpoint {
    
    static func search(
        query: String,
        page: Int
    ) -> HttpRequest {
        return HttpRequest(
            method: .GET,
            path: "/api",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "image_type", value: "photo"),
                URLQueryItem(name: "page", value: page.description)
            ]
        )
    }
    
    static let defaultPageSize: Int = 20
}
