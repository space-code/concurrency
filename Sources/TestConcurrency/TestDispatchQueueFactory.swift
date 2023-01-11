//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Concurrency
import Foundation

public final class TestDispatchQueueFactory: IDispatchQueueFactory {
    // MARK: Properties

    private let testQueue: IDispatchQueue

    // MARK: Initialization

    public init(testQueue: IDispatchQueue = TestDispatchQueue()) {
        self.testQueue = testQueue
    }

    // MARK: IDispatchQueueFactory

    public func main() -> IDispatchQueue {
        testQueue
    }

    public func global(qos _: DispatchQoS.QoSClass) -> IDispatchQueue {
        testQueue
    }

    public func privateQueue(
        label _: String,
        qos _: DispatchQoS,
        attributes _: DispatchQueue.Attributes,
        autoreleaseFrequency _: DispatchQueue.AutoreleaseFrequency,
        target _: DispatchQueue?
    ) -> IDispatchQueue {
        testQueue
    }
}
