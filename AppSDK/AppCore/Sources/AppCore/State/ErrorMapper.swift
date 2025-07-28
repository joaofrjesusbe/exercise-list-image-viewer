import Foundation

public protocol ErrorMapper {
    
    @MainActor
    func mapError(_ error: Error) -> ErrorState
}
