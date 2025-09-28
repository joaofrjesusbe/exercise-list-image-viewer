import Foundation

public struct DecoderMessage {
    
    public static func fromError(_ error: Error) -> String {
        guard let decodeError = error as? DecodingError else {
            return error.localizedDescription
        }
        
        func pathString(_ path: [CodingKey]) -> String {
            var result = ""
            for key in path {
                if let idx = key.intValue {
                    result += "[\(idx)]"
                } else {
                    result += result.isEmpty ? key.stringValue : ".\(key.stringValue)"
                }
            }
            return result.isEmpty ? "<root>" : result
        }
        
        func appendUnderlying(_ msg: String, _ underlying: Error?) -> String {
            guard let underlying else { return msg }
            return "\(msg) (\(underlying.localizedDescription))"
        }
        
        switch decodeError {
        case .dataCorrupted(let context):
            let base = "Data corrupted at \(pathString(context.codingPath)): \(context.debugDescription)"
            return appendUnderlying(base, context.underlyingError)
            
        case .keyNotFound(let key, let context):
            // Include the missing key at the end of the path
            let fullPath = pathString(context.codingPath + [key])
            let base = "Key '\(key.stringValue)' not found at \(fullPath): \(context.debugDescription)"
            return appendUnderlying(base, context.underlyingError)
            
        case .typeMismatch(let expectedType, let context):
            let base = "Type mismatch for \(expectedType) at \(pathString(context.codingPath)): \(context.debugDescription)"
            return appendUnderlying(base, context.underlyingError)
            
        case .valueNotFound(let expectedType, let context):
            let base = "Value of type \(expectedType) not found at \(pathString(context.codingPath)): \(context.debugDescription)"
            return appendUnderlying(base, context.underlyingError)
            
        @unknown default:
            return error.localizedDescription
        }
    }
    
}
