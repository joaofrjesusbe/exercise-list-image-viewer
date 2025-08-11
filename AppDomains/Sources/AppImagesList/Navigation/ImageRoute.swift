import AppCore
import PixbayNetwork

public enum ImageRoute: Routable {
    case detail(_ index: Int)
    
    
    public var debugDescription: String {
        switch self {
        case .detail(let value):
            return "ImageRoute.detail(\(value))"
        }
    }
}
