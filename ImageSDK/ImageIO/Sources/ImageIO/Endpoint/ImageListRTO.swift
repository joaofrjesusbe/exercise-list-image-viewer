import Foundation

struct ImageListRTO: Codable {
    let total: Int
    let totalHits: Int
    let hits: [ImageInfo]
}
