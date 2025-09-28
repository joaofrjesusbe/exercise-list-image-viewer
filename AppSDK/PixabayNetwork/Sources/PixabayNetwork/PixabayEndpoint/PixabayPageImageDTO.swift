import Foundation

struct PixabayPageImageDTO: Codable {
    let total: UInt
    let totalHits: UInt
    let hits: [PixabayImageDTO]
}
