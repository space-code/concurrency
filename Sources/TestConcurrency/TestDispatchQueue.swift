//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Concurrency
import Foundation

// MARK: - TestDispatchQueue

public final class TestDispatchQueue {
    public init() {}
}

// MARK: IDispatchQueue

extension TestDispatchQueue: IDispatchQueue {
    public func sync(execute block: () -> Void) {
        block()
    }

    public func async(
        qos _: DispatchQoS,
        flags _: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    ) {
        work()
    }

    public func asyncAfter(
        deadline _: DispatchTime,
        qos _: DispatchQoS,
        flags _: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    ) {
        work()
    }

    public func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }

    public func async(execute workItem: DispatchWorkItem) {
        workItem.perform()
    }

    public func sync(execute workItem: DispatchWorkItem) {
        workItem.perform()
    }
}
