import AppCore
import PixbayNetwork

public enum ImageRoute: Routable {
    case home
    case detail(_ index: Int)
    
    public static func homeRoute() -> ImageRoute {
        .home
    }
    
    public var debugDescription: String {
        switch self {
        case .home:
            return "ImageRoute.home"
        case .detail(let value):
            return "ImageRoute.detail(\(value))"
        }
    }
}
