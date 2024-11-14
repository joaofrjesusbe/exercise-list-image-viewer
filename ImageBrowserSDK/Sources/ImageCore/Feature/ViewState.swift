import Foundation

public enum ViewState<Object, Error> {
    case idle
    case loading
    case didLoad(Object)
    case failed(Error)
}
