import Foundation

public protocol ErrorMapper {
    
    func mapError(_ error: Error) -> ErrorState
}
