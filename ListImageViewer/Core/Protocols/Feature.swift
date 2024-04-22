import SwiftUI

protocol Feature {
    associatedtype RootView: View

    var rootView: RootView { get }
}
