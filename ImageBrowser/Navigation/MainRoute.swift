import ImageCore
import ImageIO

enum MainRoute: Routable {
    case home
    case detail(ImageInfo)
    
    static func homeRoute() -> MainRoute {
        .home
    }
}
