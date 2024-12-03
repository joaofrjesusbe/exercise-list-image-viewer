import ImageIO
import ImageDS

public enum ImageRoute: Routable {
    case home
    case detail(ImageInfo)
    
    public static func homeRoute() -> ImageRoute {
        .home
    }
}
