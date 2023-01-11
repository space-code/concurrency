//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - IDispatchQueueFactory

public protocol IDispatchQueueFactory {
    /// The dispatch queue associated with the main thread of the current process.
    func main() -> IDispatchQueue

    /// Returns the global system queue with the specified quality-of-service class.
    func global(qos: DispatchQoS.QoSClass) -> IDispatchQueue

    /// An object that manages the execution of tasks serially or concurrently on your
    /// app's main thread or on a background thread.
    func privateQueue(
        label: String,
        qos: DispatchQoS,
        attributes: DispatchQueue.Attributes,
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency,
        target: DispatchQueue?
    ) -> IDispatchQueue
}

public extension IDispatchQueueFactory {
    func privateQueue(label: String) -> IDispatchQueue {
        privateQueue(label: label, qos: .unspecified, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
}
