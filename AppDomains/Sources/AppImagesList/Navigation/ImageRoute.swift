import AppCore
import PixbayNetwork

public enum ImageRoute: Routable {
    case listing
    case detail(_ index: Int)
    
    public static func homeRoute() -> ImageRoute {
        .listing
    }
    
    public var debugDescription: String {
        switch self {
        case .listing:
            return "ImageRoute.home"
        case .detail(let value):
            return "ImageRoute.detail(\(value))"
        }
    }
}
