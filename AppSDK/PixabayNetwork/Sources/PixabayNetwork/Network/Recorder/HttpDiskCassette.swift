import Foundation
import CryptoKit
import AppCore

public enum ReplayError: Error { case notFound }

// WARNING: Most of the code from this class was generated from AI
public actor HttpDiskCassette: NetworkRequestInterceptor, NetworkResponseInterceptor {
    @Injected(\.logger) var logger
    
    /// Writable root (e.g. Library/Caches/NetworkRecords)
    public let root: URL
    /// Additional read-only cassette roots (e.g. in app bundle)
    public let readOnlyRoots: [URL]
    private let stripQueryNames: Set<String>
    private let io = DispatchQueue(label: "io.diskcassette", qos: .utility)
    private var warningAlreadyPresented = false
    
    public init(
        folderName: String = "NetworkRecords",
        baseDirectory: FileManager.SearchPathDirectory = .cachesDirectory,
        readOnlyRoots: [URL] = [],
        stripQueryNames: Set<String> = ["key", "apikey", "api_key", "token"]
    ) {
        let fm = FileManager()
        let base = fm.urls(for: baseDirectory, in: .userDomainMask).first!
        self.root = base.appendingPathComponent(folderName, isDirectory: true)
        try? fm.createDirectory(at: root, withIntermediateDirectories: true)
        self.readOnlyRoots = readOnlyRoots
        self.stripQueryNames = Set(stripQueryNames.map { $0.lowercased() })
    }
    
    // MARK: Request interceptor (short-circuit)
    public func request(_ request: inout URLRequest) async throws -> NetworkResponse? {
        do { return try await replay(for: request) }
        catch ReplayError.notFound { return nil }
    }
    
    // MARK: Replay (search writable root, then bundle roots)
    public func replay(for request: URLRequest) async throws -> NetworkResponse {
        let searchPaths = [root.path] + readOnlyRoots.map { $0.path }
        let strip = stripQueryNames
        
        let result: NetworkResponse = try await withCheckedThrowingContinuation {
            (cont: CheckedContinuation<NetworkResponse, Error>) in
            io.async {
                do {
                    let value = try CassetteFileSystem.load(
                        searchRootPaths: searchPaths,
                        request: request,
                        stripNames: strip
                    )
                    cont.resume(returning: value)
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
        
        logger.network("Replaying")
        return result
    }
    
    // MARK: Response interceptor (record successes)
    public func adaptResponse(request: URLRequest, response: inout NetworkResponse?, error: inout (any Error)?) async {
        if let res = response, let httpResponse = res.urlResponse as? HTTPURLResponse {
            await record(request: request, response: httpResponse, data: res.data)
        }
        // If you later throw an error carrying (HTTPURLResponse, Data),
        // you can inspect & record failures here too.
    }
    
    // MARK: Record (writes only to writable root)
    public func record(request: URLRequest, response: HTTPURLResponse, data: Data) async {
        let rootPath = root.path
        let strip = stripQueryNames
        
        // Non-throwing continuation returning an optional path (no String-as-Error)
        let savedPath: String? = await withCheckedContinuation { (cont: CheckedContinuation<String?, Never>) in
            io.async { cont.resume(returning: CassetteFileSystem.record(rootPath: rootPath, request: request, response: response, data: data, stripNames: strip)) }
        }
        
        guard  savedPath != nil else {
            logger.error("DiskCassette: failed to record cassette")
            return
        }
        
        if !warningAlreadyPresented {
            logger.warning("Network records at:\nopen file://\(rootPath)")
            warningAlreadyPresented = true
        }
    }
    
    // MARK: Optional: seed cache from a bundled root if empty
    public func seedIfEmpty(from bundleRoot: URL) async throws {
        let destPath = root.path, srcPath = bundleRoot.path
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            io.async {
                do { try CassetteFileSystem.seedIfEmpty(destRootPath: destPath, bundleRootPath: srcPath); cont.resume() }
                catch { cont.resume(throwing: error) }
            }
        }
    }
}
