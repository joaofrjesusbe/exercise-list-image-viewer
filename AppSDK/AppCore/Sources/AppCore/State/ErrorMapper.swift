import Foundation

public protocol ErrorMapper: Sendable {
    
    @MainActor
    func mapError(_ error: Error) -> ErrorState
}
