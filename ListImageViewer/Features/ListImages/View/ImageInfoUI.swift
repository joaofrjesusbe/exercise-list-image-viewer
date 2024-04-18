import Foundation

struct ImageInfoUI: Identifiable, Hashable, Equatable {
    let id: Int
    let url: URL?
    let user: String
    let likes: Int

    static var mock: ImageInfoUI {
        ImageInfo.mock.toImageInfoUIModel()
    }
}

extension ImageInfo {

    func toImageInfoUIModel() -> ImageInfoUI {
        ImageInfoUI(
            id: id,
            url: URL(string: previewURL),
            user: user,
            likes: likes
        )
    }
}
