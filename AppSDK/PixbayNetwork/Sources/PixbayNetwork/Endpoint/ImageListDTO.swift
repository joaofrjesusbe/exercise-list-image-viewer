import Foundation

struct ImageListDTO: Codable {
    let total: UInt
    let totalHits: UInt
    let hits: [ImageInfo]
}
