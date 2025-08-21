import Foundation

public enum LocalizedString {
    case key(String, arguments: [CVarArg] = [])
    case plain(String)
}
