import Foundation

public enum ViewState<Model, Error> {
    case idle
    case loading
    case didLoad(Model)
    case failed(Error)
}
