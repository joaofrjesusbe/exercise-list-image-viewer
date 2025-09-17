import Foundation
import Nuke

// MARK: - NetworkRequest-backed DataLoader for Nuke

/// Bridges our custom `NetworkRequest` pipeline into Nuke via `DataLoading`.
final class NukeDataLoader: DataLoading, Sendable {
    private let network: NetworkRequest

    init(network: NetworkRequest) {
        self.network = network
    }

    func loadData(
        with request: URLRequest,
        didReceiveData: @escaping (Data, URLResponse) -> Void,
        completion: @escaping (Error?) -> Void
    ) -> any Cancellable {
        // Wrap callbacks to avoid sending non-sendable closures across concurrency domains
        let callbacks = CallbackBox(didReceiveData: didReceiveData, completion: completion)
        let task = Task {
            do {
                let (data, response) = try await network.request(for: request)
                await callbacks.receive(data: data, response: response)
                await callbacks.complete(nil)
            } catch {
                await callbacks.complete(error)
            }
        }
        return TaskCancellable(task)
    }
}

private final class TaskCancellable: Cancellable, Sendable {
    private let task: Task<Void, Never>
    init(_ task: Task<Void, Never>) { self.task = task }
    func cancel() { task.cancel() }
}

// Box closures and invoke them on the main actor to avoid data races.
private final class CallbackBox: @unchecked Sendable {
    private let _didReceive: (Data, URLResponse) -> Void
    private let _complete: (Error?) -> Void

    init(didReceiveData: @escaping (Data, URLResponse) -> Void,
         completion: @escaping (Error?) -> Void) {
        self._didReceive = didReceiveData
        self._complete = completion
    }

    @MainActor
    func receive(data: Data, response: URLResponse) {
        _didReceive(data, response)
    }

    @MainActor
    func complete(_ error: Error?) {
        _complete(error)
    }
}

