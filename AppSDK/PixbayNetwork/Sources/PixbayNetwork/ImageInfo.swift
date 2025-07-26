import Foundation

public struct ImageInfo: Codable, Identifiable, Hashable, Sendable, Equatable {
    public let id: Int
    public let previewURL: String
    public let largeImageURL: String
    public let user: String
    public let likes: Int
}

public extension ImageInfo {
    static var mock: ImageInfo {
        ImageInfo(
            id: Int.random(in: 0...Int.max),
            previewURL: "https://mock.previewURL.com",
            largeImageURL: "https://mock.largeImageURL.com",
            user: "User",
            likes: 100
        )
    }
}
