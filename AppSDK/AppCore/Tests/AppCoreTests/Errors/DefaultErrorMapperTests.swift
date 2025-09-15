@testable import AppCore
import Foundation
import Testing

final class DefaultErrorMapperTests: @unchecked Sendable {
    private let mapper = DefaultErrorMapper()

    @Test
    func maps_urlerror_offline_to_offline_key() async throws {
        let error = URLError(.notConnectedToInternet)
        let state = await mapper.mapError(error)
        #expect(state.title == L10n.errorTitle)
        #expect(state.description == L10n.errorNetworkOffline)
    }

    @Test
    func maps_urlerror_timeout_to_timeout_key() async throws {
        let error = URLError(.timedOut)
        let state = await mapper.mapError(error)
        #expect(state.title == L10n.errorTitle)
        #expect(state.description == L10n.errorNetworkTimeout)
    }

    @Test
    func maps_other_urlerror_to_generic_key() async throws {
        let error = URLError(.cannotFindHost)
        let state = await mapper.mapError(error)
        #expect(state.title == L10n.errorTitle)
        #expect(state.description == L10n.errorNetworkGeneric)
    }

    @Test
    func maps_decoding_error_to_parsing_key() async throws {
        let error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
        let state = await mapper.mapError(error)
        #expect(state.title == L10n.errorTitle)
        #expect(state.description == L10n.errorNetworkParsing)
    }

    private struct LocalErr: LocalizedError { let errorDescription: String? }

    @Test
    func passes_through_localized_error_description_as_plain_text() async throws {
        let error = LocalErr(errorDescription: "Oops")
        let state = await mapper.mapError(error)
        // Title remains generic
        #expect(state.title == L10n.errorTitle)
        // Description becomes the provided string literal
        let value = String(localized: state.description)
        #expect(value == "Oops")
    }
}

