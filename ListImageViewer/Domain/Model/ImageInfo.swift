import Foundation

public struct ImageInfo: Codable, Identifiable, Hashable {
    public let id: Int
    public let previewURL: String
    public let user: String
    public let likes: Int
}

extension ImageInfo {
    static var mock: ImageInfo {
        ImageInfo(
            id: Int.random(in: 0...Int.max),
            previewURL: "https://previewURL.com",
            user: "User",
            likes: 100
        )
    }
}
