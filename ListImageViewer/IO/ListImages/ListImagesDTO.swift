import Foundation

struct ListImagesDTO: Codable {
    let total: Int
    let totalHits: Int
    let hits: [ImageInfo]
}
