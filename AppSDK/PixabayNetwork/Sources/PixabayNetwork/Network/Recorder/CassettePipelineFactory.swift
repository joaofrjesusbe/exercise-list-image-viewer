import Foundation

public enum NetworkMode { case live, record, auto, replay }

public final class CassettePipelineFactory {
    let networkMode: NetworkMode
    let mainRequest: NetworkRequest
    let cassette: HttpDiskCassette
    
    init(
        networkMode: NetworkMode,
        mainRequest: NetworkRequest
    ) {
        self.networkMode = networkMode
        self.mainRequest = mainRequest
        self.cassette = Self.createCassette()
    }
    
    func createOriginalNetwork() -> NetworkRequest {
        return mainRequest
    }
    
    func createCasseteNetwork(
        requestInterceptors: [NetworkRequestInterceptor] = [],
        responseInterceptors: [NetworkResponseInterceptor] = [],
    ) -> NetworkRequest {
        let mainRequest: NetworkRequest = (networkMode == .replay) ? FailingNetwork() : mainRequest

        return NetworkPipeline(
            mainRequest: mainRequest,
            requestInterceptors: appendRequestInterceptors(cassette: cassette, interceptors: requestInterceptors),
            responseInterceptors: appendResponseInterceptors(cassette: cassette, interceptors: responseInterceptors)
        )
    }
    
    private func appendRequestInterceptors(
        cassette: HttpDiskCassette,
        interceptors: [NetworkRequestInterceptor]
    ) -> [NetworkRequestInterceptor] {
        
        var interceptors = interceptors
        
        switch networkMode {
        case .auto, .replay:
            interceptors.append(cassette)
        case .live, .record:
            break
        }
        
        return interceptors
    }
    
    private func appendResponseInterceptors(
        cassette: HttpDiskCassette,
        interceptors: [NetworkResponseInterceptor]
    ) -> [NetworkResponseInterceptor] {
        
        var interceptors = interceptors
        
        switch networkMode {
        case .record, .auto:
            interceptors.append(cassette)
        case .live, .replay:
            break
        }
        
        return interceptors
    }
    
    static private func createCassette() -> HttpDiskCassette {
        let bundledRoot = Bundle.module.url(forResource: "PixabayRecords", withExtension: nil)

        let cassette = HttpDiskCassette(
            folderName: "PixabayRecords",
            baseDirectory: .cachesDirectory,
            readOnlyRoots: bundledRoot.map { [$0] } ?? []
        )

        return cassette
    }
}
