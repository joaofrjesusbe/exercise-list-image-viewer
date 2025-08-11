import SwiftUI

@MainActor
open class IntentSendable<Intent> {
    
    open func send(_ intent: Intent) {
        fatalError("Subclasses must override send(_:) method")
    }
}
