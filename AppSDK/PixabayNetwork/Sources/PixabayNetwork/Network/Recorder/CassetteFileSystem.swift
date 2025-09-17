import Foundation
import CryptoKit

// WARNING: Most of the code from this class was generated from AI
public enum CassetteFileSystem {
    // File names
    private static let requestFile      = "request.json"
    private static let responseMetaFile = "response.meta.json"

    // Models
    private struct RequestMeta: Codable {
        let url: String
        let method: String
        let headers: [String:String]
        let timestamp: String
    }

    private struct ResponseMeta: Codable {
        let status: Int
        let headers: [String:String]
        let contentType: String?
        let timestamp: String
    }

    // Load from split files (no legacy fallback)
    static func load(searchRootPaths: [String], request: URLRequest, stripNames: Set<String>) throws -> NetworkResponse {
        let key = requestKey(for: request, stripNames: stripNames)

        for rootPath in searchRootPaths {
            let dir = URL(fileURLWithPath: rootPath, isDirectory: true).appendingPathComponent(key, isDirectory: true)

            // meta
            let metaURL = dir.appendingPathComponent(responseMetaFile)
            guard
                let metaData = try? Data(contentsOf: metaURL),
                let meta = try? JSONDecoder().decode(ResponseMeta.self, from: metaData)
            else { continue }

            // body
            guard let bodyURL = pickBodyFileURL(in: dir),
                  let body = try? Data(contentsOf: bodyURL)
            else { continue }

            // URL for HTTPURLResponse: prefer the live request URL, else sanitized URL from request.json
            let url: URL = {
                if let u = request.url { return u }
                if
                    let reqData = try? Data(contentsOf: dir.appendingPathComponent(requestFile)),
                    let req = try? JSONDecoder().decode(RequestMeta.self, from: reqData),
                    let u = URL(string: req.url)
                { return u }
                return URL(string: "about:blank")!
            }()

            let http = HTTPURLResponse(url: url, statusCode: meta.status, httpVersion: "HTTP/1.1", headerFields: meta.headers)!
            return (body, http)
        }

        throw ReplayError.notFound
    }

    // Record split files
    static func record(rootPath: String, request: URLRequest, response: HTTPURLResponse, data: Data, stripNames: Set<String>) -> String? {
        let fm = FileManager()
        let root = URL(fileURLWithPath: rootPath, isDirectory: true)

        let key = requestKey(for: request, stripNames: stripNames)
        let dir = root.appendingPathComponent(key, isDirectory: true)

        do {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)

            // request.json (sanitized URL & headers)
            let reqMeta = RequestMeta(
                url: sanitizedURLString(from: request.url, stripNames: stripNames),
                method: request.httpMethod ?? "GET",
                headers: request.allHTTPHeaderFields ?? [:],
                timestamp: ISO8601DateFormatter().string(from: Date())
            )
            try JSONEncoder().encode(reqMeta)
                .write(to: dir.appendingPathComponent(requestFile), options: .atomic)

            // response.meta.json
            let respHeaders = response.allHeaderFields.reduce(into: [String:String]()) {
                if let k = $1.key as? String, let v = $1.value as? CustomStringConvertible { $0[k] = v.description }
            }
            let respMeta = ResponseMeta(
                status: response.statusCode,
                headers: respHeaders,
                contentType: respHeaders["Content-Type"],
                timestamp: ISO8601DateFormatter().string(from: Date())
            )
            try JSONEncoder().encode(respMeta)
                .write(to: dir.appendingPathComponent(responseMetaFile), options: .atomic)

            // response body (raw)
            let isJSON = bodyLooksJSON(contentType: respMeta.contentType, data: data)
            let bodyName = bodyFileName(contentType: respMeta.contentType, isJSON: isJSON)
            try data.write(to: dir.appendingPathComponent(bodyName), options: .atomic)

            return dir.path
        } catch {
            return nil
        }
    }

    // Seed cache from bundle if empty
    static func seedIfEmpty(destRootPath: String, bundleRootPath: String) throws {
        let fm = FileManager()
        let dest = URL(fileURLWithPath: destRootPath, isDirectory: true)
        let src  = URL(fileURLWithPath: bundleRootPath, isDirectory: true)

        if let e = fm.enumerator(at: dest, includingPropertiesForKeys: nil), e.nextObject() != nil { return }

        for item in try fm.contentsOfDirectory(at: src, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) {
            let to = dest.appendingPathComponent(item.lastPathComponent, isDirectory: true)
            if fm.fileExists(atPath: to.path) { continue }
            try fm.copyItem(at: item, to: to)
        }
    }

    // ---------- Pure helpers (hashing / URLs / body typing) ----------

    private static func requestKey(for req: URLRequest, stripNames: Set<String>) -> String {
        let m = req.httpMethod ?? "GET"
        let b = sha256(req.httpBody ?? Data())
        let url = normalize(url: req.url, stripNames: stripNames)
        let escapedUrl = safeStripBaseURL(url)
        let u = url?.absoluteString ?? ""
        return "\(m)_\(escapedUrl)_\(sha256(Data("\(m)|\(u)|\(b)".utf8)))"
    }
    
    private static func safeStripBaseURL(_ url: URL?) -> String {
        guard let url else { return "" }
        var c = URLComponents(url: url, resolvingAgainstBaseURL: false)
        c?.scheme = nil
        c?.host = nil
        
        var rest = c?.url?.absoluteString ?? ""
        
        if rest.hasPrefix("/") {
            rest = String(rest.dropFirst())
        }
        return rest.replacingOccurrences(of: "/", with: "_")
    }

    private static func normalize(url: URL?, stripNames: Set<String>) -> URL? {
        guard let url, var c = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        if let items = c.queryItems, !items.isEmpty {
            // remove any items whose name matches stripNames (case-insensitive)
            let filtered = items.filter { !stripNames.contains($0.name.lowercased()) }
            c.queryItems = filtered.sorted {
                if $0.name == $1.name { ($0.value ?? "") < ($1.value ?? "") }
                else { $0.name < $1.name }
            }
        }
        c.fragment = nil
        return c.url ?? url
    }

    private static func sanitizedURLString(from url: URL?, stripNames: Set<String>) -> String {
        guard let url else { return "" }
        var c = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let items = c?.queryItems, !items.isEmpty {
            c?.queryItems = items.filter { !stripNames.contains($0.name.lowercased()) }
        }
        c?.fragment = nil
        return c?.url?.absoluteString ?? url.absoluteString
    }

    static func bodyLooksJSON(contentType: String?, data: Data) -> Bool {
        if let ct = contentType?.lowercased(), ct.contains("json") { return true }
        if let s = String(data: data, encoding: .utf8) {
            let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
            return t.first == "{" || t.first == "["
        }
        return false
    }

    static func bodyFileName(contentType: String?, isJSON: Bool) -> String {
        if isJSON { return "response.json" }
        guard let ct = contentType?.lowercased() else { return "response.bin" }
        if ct.hasPrefix("text/html")   { return "response.html" }
        if ct.hasPrefix("text/plain")  { return "response.txt" }
        if ct.hasPrefix("image/png")   { return "response.png" }
        if ct.hasPrefix("image/jpeg")  { return "response.jpg" }
        if ct.hasPrefix("image/gif")   { return "response.gif" }
        if ct.hasPrefix("application/pdf") { return "response.pdf" }
        return "response.bin"
    }

    static func pickBodyFileURL(in dir: URL) -> URL? {
        let candidates = [
            "response.json","response.txt","response.png","response.jpg",
            "response.jpeg","response.gif","response.pdf","response.bin"
        ]
        for name in candidates {
            let u = dir.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: u.path) { return u }
        }
        if let list = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) {
            return list.first { $0.lastPathComponent.hasPrefix("response.") }
        }
        return nil
    }

    static func sha256(_ d: Data) -> String {
        let digest = SHA256.hash(data: d)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
