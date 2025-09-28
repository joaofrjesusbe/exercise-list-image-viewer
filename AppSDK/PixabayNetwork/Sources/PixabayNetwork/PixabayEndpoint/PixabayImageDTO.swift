import Foundation

struct PixabayImageDTO: Codable {
    let id: UInt64
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: UInt
    let views: Int
    let downloads: Int
    let collections: Int
    let likes: Int
    let comments: Int
    let user_id: UInt64
    let user: String
    let userImageURL: String
    let noAiTraining: Bool
    let isAiGenerated: Bool
    let isGRated: Bool
    let isLowQuality: Bool
    let userURL: String
}

extension PixabayImageDTO {
    
    func toModel() -> ImageInfo {
        ImageInfo(id: id, previewURL: previewURL, largeImageURL: largeImageURL, user: user, likes: likes)
    }
}
