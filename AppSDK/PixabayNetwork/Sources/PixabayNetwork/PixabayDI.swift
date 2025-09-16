import Foundation
import AppCore
import Nuke

public enum NetworkMode { case live, record, auto, replay }

public extension Container {
    var networkMode: Factory<NetworkMode> {
        Factory(self) { .live }.singleton
    }

    var cassette: Factory<HttpDiskCassette> {
        Factory(self) {
            let bundledRoot = Bundle.module.url(forResource: "PixabayRecords", withExtension: nil)

            let cassette = HttpDiskCassette(
                folderName: "PixabayRecords",
                baseDirectory: .cachesDirectory,
                readOnlyRoots: bundledRoot.map { [$0] } ?? []
            )

            return cassette
        }.singleton
    }

    var networkBackend: Factory<NetworkRequest> {
        Factory(self) { NetworkSessionRequest(session: .shared) }
    }

    var requestInterceptors: Factory<[NetworkRequestInterceptor]> {
        Factory(self) { [
            APIKeyInterceptor(key: PIXABAY_API_KEY),
            NetworkLoggerInterceptor()
        ] }
    }

    var responseInterceptors: Factory<[NetworkResponseInterceptor]> {
        Factory(self) {
            switch self.networkMode() {
            case .record, .auto: return [self.cassette()]
            default: return []
            }
        }
    }

    var networkPipeline: Factory<NetworkRequest> {
        Factory(self) {
            let reqs: [NetworkRequestInterceptor] = {
                var list = self.requestInterceptors()
                switch self.networkMode() {
                case .auto, .replay:
                    list.append(self.cassette())
                case .live, .record:
                    break
                }
                return list
            }()

            let backend: NetworkRequest = (self.networkMode() == .replay) ? FailingNetwork() : self.networkBackend()

            return NetworkPipeline(
                network: backend,
                requestInterceptors: reqs,
                responseInterceptors: self.responseInterceptors()
            )
        }
        .singleton
    }

    var httpClient: Factory<HttpClientType> {
        Factory(self) {
            guard let baseURL = URL(string: "https://pixabay.com/api") else { fatalError("Bad baseURL") }
            return HttpClient(baseURL: baseURL, networkRequest: self.networkPipeline.resolve())
        }
        .singleton
    }
    
    /// Data loader that uses the image-specific pipeline (no API key/logging).
    var nukeDataLoader: Factory<any DataLoading> {
        Factory(self) {
            NetworkRequestDataLoader(network: self.imageNetworkPipeline())
        }.singleton
    }

    /// Nuke pipeline configured to use our custom data loader.
    var nukeImagePipeline: Factory<ImagePipeline> {
        Factory(self) {
            ImagePipeline { config in
                config.dataLoader = self.nukeDataLoader()
                // You can enable data cache here if desired, e.g.:
                // config.dataCache = try? DataCache(name: "com.example.images")
                // config.dataCachePolicy = .automatic
            }
        }.singleton
    }

    /// High-level loader API used by UI layers.
    var imageLoader: Factory<ImageLoader> {
        Factory(self) {
            ImageLoader(pipeline: self.nukeImagePipeline())
        }.singleton
    }

    /// A specialized pipeline for image loading that avoids API key and
    /// request logging interceptors, but preserves cassette record/replay.
    var imageNetworkPipeline: Factory<NetworkRequest> {
        Factory(self) {
            let reqs: [NetworkRequestInterceptor] = {
                switch self.networkMode() {
                case .auto, .replay:
                    return [self.cassette()]
                case .live, .record:
                    return []
                }
            }()

            let backend: NetworkRequest = (self.networkMode() == .replay) ? FailingNetwork() : self.networkBackend()

            return NetworkPipeline(
                network: backend,
                requestInterceptors: reqs,
                responseInterceptors: self.responseInterceptors()
            )
        }.singleton
    }
}
