import Foundation

struct ImageInfoUI: Identifiable, Hashable, Equatable {
    let id: Int
    let preview: URL?
    let detail: URL?
    let user: String
    let likes: String

    init(_ imageInfo: ImageInfo) {
        self.id = imageInfo.id
        self.preview = URL(string: imageInfo.previewURL)
        self.detail = URL(string: imageInfo.largeImageURL)
        self.user = "User: \(imageInfo.user)"
        self.likes = "Likes: \(imageInfo.likes)"
    }

    static var mock: ImageInfoUI {
        ImageInfoUI(ImageInfo.mock)
    }
}
