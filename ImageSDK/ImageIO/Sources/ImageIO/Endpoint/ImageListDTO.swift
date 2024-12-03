import Foundation

struct ImageListDTO: Codable {
    let total: Int
    let totalHits: Int
    let hits: [ImageInfo]
}
