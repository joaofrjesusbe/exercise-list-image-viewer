import Foundation

public final class DiskRecorder: NetworkRecorder {
    private let root: URL
    private let fileManager: FileManager

    public init(folderName: String = "NetworkRecords",
                fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.root = caches.appendingPathComponent(folderName, isDirectory: true)
        try? fileManager.createDirectory(at: root, withIntermediateDirectories: true)
    }

    public func record(request: URLRequest, response: HTTPURLResponse, data: Data) async {
        let ts = ISO8601DateFormatter().string(from: Date())
        let safePath = (request.url?.path.isEmpty == false ? request.url!.path : "/")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "_"))

        let folder = root
            .appendingPathComponent("\(response.statusCode)_\(request.httpMethod ?? "GET")_\(safePath)_\(ts)", isDirectory: true)

        do {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)

            // meta
            let meta: [String: Any] = [
                "url": request.url?.absoluteString ?? "",
                "method": request.httpMethod ?? "",
                "status": response.statusCode,
                "requestHeaders": request.allHTTPHeaderFields ?? [:],
                "responseHeaders": response.allHeaderFields,
                "timestamp": ts
            ]
            let metaData = try JSONSerialization.data(withJSONObject: meta, options: [.prettyPrinted, .sortedKeys])
            try metaData.write(to: folder.appendingPathComponent("meta.json"))

            // payload
            if isLikelyJSON(data: data) {
                try data.write(to: folder.appendingPathComponent("response.json"))
            } else {
                try data.write(to: folder.appendingPathComponent("response.bin"))
            }
        } catch {
            // If recording fails, we swallow the error to not affect networking.
            // You can route this to your logger if desired.
            #if DEBUG
            print("DiskRecorder error: \(error)")
            #endif
        }
    }

    private func isLikelyJSON(data: Data) -> Bool {
        guard let s = String(data: data, encoding: .utf8) else { return false }
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.hasPrefix("{") || t.hasPrefix("[")
    }
}
