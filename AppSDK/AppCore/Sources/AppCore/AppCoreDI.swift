@_exported import FactoryKit

public extension Container {
    
    var logger: Factory<Logger> {
        Factory(self) { ConsoleLogger() }
    }
}
