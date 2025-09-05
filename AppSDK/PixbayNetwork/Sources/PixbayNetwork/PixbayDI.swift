import AppCore

public extension Container {
    var shouldRecordResponses: Factory<Bool> { Factory(self) { true } }

    var httpClient: Factory<HTTPClientType> {
        Factory(self) {
            guard let baseURL = PixbayEndpoint.baseUrl else { fatalError("Bad baseURL") }
            let recorder: NetworkRecorder? = self.shouldRecordResponses() ? DiskRecorder(folderName: "PixabayRecords") : nil
            return HTTPClient(baseURL: baseURL, session: .shared, recorder: recorder)
        }
        .singleton
    }
}
