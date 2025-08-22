import Foundation

public enum LocalizedString {
    case key(LocalizedKey, arguments: [CVarArg] = [])
    case plain(String)
}
