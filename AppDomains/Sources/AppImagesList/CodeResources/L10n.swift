import AppCore

@MainActor
enum L10n {
    static let user = LocalizedKey("images.user")
    static let likes = LocalizedKey("images.likes")
    static let listTitle = LocalizedKey("images.list.title")
    static let detailTitle = LocalizedKey("images.detail.title")
}
