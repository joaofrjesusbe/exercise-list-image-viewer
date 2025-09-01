import Foundation

// MARK: - Typed, Sendable, Equatable localization args
public enum L10nArg: Sendable, Equatable, Hashable {
    case string(String)
    case int(Int)
    case double(Double)
    case float(Float)
    case bool(Bool)
}

public extension L10nArg {
    var asCVarArg: CVarArg {
        switch self {
        case .string(let s): s
        case .int(let i): i
        case .double(let d): d
        case .float(let f): f
        case .bool(let b): b ? 1 : 0
        }
    }
}

// Ergonomic conversions so you can pass plain values
public protocol L10nArgConvertible {
    var l10nArg: L10nArg { get }
}
extension String: L10nArgConvertible { public var l10nArg: L10nArg { .string(self) } }
extension Int:    L10nArgConvertible { public var l10nArg: L10nArg { .int(self) } }
extension Double: L10nArgConvertible { public var l10nArg: L10nArg { .double(self) } }
extension Float:  L10nArgConvertible { public var l10nArg: L10nArg { .float(self) } }
extension Bool:   L10nArgConvertible { public var l10nArg: L10nArg { .bool(self) } }
