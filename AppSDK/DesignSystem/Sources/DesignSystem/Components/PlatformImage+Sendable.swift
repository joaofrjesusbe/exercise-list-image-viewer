import Foundation

#if canImport(UIKit)
import UIKit
extension UIImage: @unchecked Sendable {}
#elseif canImport(AppKit)
import AppKit
extension NSImage: @unchecked Sendable {}
#endif

