import Foundation
import AppCore

public enum NetworkMode { case live, record, auto, replay }

public extension Container {
    var networkMode: Factory<NetworkMode> {
        Factory(self) { .auto }.singleton
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
        Factory(self) { [APIKeyInterceptor(key: PIXBAY_API_KEY)] }
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
}
