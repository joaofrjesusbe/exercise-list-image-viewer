import Foundation
import AppCore
import Nuke

public extension Container {
    var networkMode: Factory<NetworkMode> {
        // Default to .replay to prevent accidental live calls without config
        self { .replay }.singleton
    }
    
    var cassettePipelineFactory: Factory<CassettePipelineFactory> {
        self {
            CassettePipelineFactory(
                networkMode: self.networkMode.resolve(),
                mainRequest: NetworkSessionRequest()
            )
        }.singleton
    }

    var networkPipeline: Factory<NetworkRequest> {
        self {
            let factory = self.cassettePipelineFactory.resolve()
            return factory.createCasseteNetwork(
                requestInterceptors: [
                    APIKeyInterceptor(key: PIXABAY_API_KEY),
                    NetworkLoggerInterceptor()
                ],
                responseInterceptors: []
            )
        }
        .singleton
    }

    var httpClient: Factory<HttpClientType> {
        self {
            guard let baseURL = URL(string: "https://pixabay.com/api") else { fatalError("Bad baseURL") }
            return HttpClient(baseURL: baseURL, networkRequest: self.networkPipeline.resolve())
        }
        .singleton
    }

    /// High-level loader API used by UI layers.
    var imageLoader: Factory<ImageLoader> {
        self {
            let nukeImagePipeline = ImagePipeline { config in
                
                let factory = self.cassettePipelineFactory.resolve()
                let network = factory.createOriginalNetwork()
                let nukeDataLoader = NukeDataLoader(network: network)
                
                config.dataLoader = nukeDataLoader
                config.dataCachePolicy = .automatic
            }
            
            return ImageLoader(pipeline: nukeImagePipeline)
        }.singleton
    }
}
