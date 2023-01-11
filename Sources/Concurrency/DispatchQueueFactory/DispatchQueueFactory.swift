//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

public final class DispatchQueueFactory: IDispatchQueueFactory {
    // MARK: Initialization

    public init() {}

    // MARK: Public

    public func main() -> IDispatchQueue {
        DispatchQueue.main
    }

    public func global(qos: DispatchQoS.QoSClass) -> IDispatchQueue {
        DispatchQueue.global(qos: qos)
    }

    public func privateQueue(
        label: String,
        qos: DispatchQoS,
        attributes: DispatchQueue.Attributes,
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency,
        target: DispatchQueue?
    ) -> IDispatchQueue {
        DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: target)
    }
}
