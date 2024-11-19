import ImageCore
import ImageIO

enum ImageRoute: Routable {
    case home
    case detail(ImageInfo)
    
    static func homeRoute() -> ImageRoute {
        .home
    }
}
