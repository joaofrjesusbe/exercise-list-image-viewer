import Foundation

public enum LocalizationBundles {
    nonisolated(unsafe) private static var lock = NSLock()
    nonisolated(unsafe) private static var table: [String: Bundle] = [:]

    /// Register a bundle with a stable id (e.g. "FeatureHome")
    @discardableResult
    public static func register(_ bundle: Bundle, id: String) -> String {
        lock.lock(); defer { lock.unlock() }
        table[id] = bundle
        return id
    }

    /// Lookup a bundle for an id. Tries known table, then scans as a fallback.
    public static func bundle(for id: String?) -> Bundle? {
        guard let id else { return nil }
        lock.lock(); let cached = table[id]; lock.unlock()
        if let cached { return cached }

        // Fallback scan: match bundleIdentifier or bundle filename
        let all = Bundle.allBundles + Bundle.allFrameworks
        if let found = all.first(where: { $0.bundleIdentifier == id || $0.bundleURL.lastPathComponent == id }) {
            register(found, id: id)
            return found
        }
        return nil
    }
}
