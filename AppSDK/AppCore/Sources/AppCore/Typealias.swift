import SwiftUI

public typealias Action = () -> Void

public typealias SystemImageName = String
public typealias LanguageKey = String

public typealias ListingLoadState = LoadState<Void>

public typealias LocalizedKey = String

extension LocalizedKey {
    
    var toLocalizedStringKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}
