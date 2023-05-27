//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - IDispatchQueue

public protocol IDispatchQueue: AnyObject {
    /// Schedules a block asynchronously for execution and optionally associates it with a dispatch group.
    ///
    /// - Parameter work: The block containing the work to perform. This block has no return value and no parameters.
    func async(execute work: @escaping @convention(block) () -> Void)

    ///
    /// Submits a work item to a dispatch queue for asynchronous execution after
    /// a specified time.
    ///
    /// - parameter: deadline the time after which the work item should be executed,
    /// given as a `DispatchTime`.
    /// - parameter qos: the QoS at which the work item should be executed.
    ///    Defaults to `DispatchQoS.unspecified`.
    /// - parameter flags: flags that control the execution environment of the
    /// work item.
    /// - parameter execute: The work item to be invoked on the queue.
    /// - SeeAlso: `async(execute:)`
    /// - SeeAlso: `asyncAfter(deadline:execute:)`
    /// - SeeAlso: `DispatchQoS`
    /// - SeeAlso: `DispatchWorkItemFlags`
    /// - SeeAlso: `DispatchTime`
    ///
    func asyncAfter(
        deadline: DispatchTime,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    )

    ///
    /// Submits a work item to a dispatch queue and optionally associates it with a
    /// dispatch group. The dispatch group may be used to wait for the completion
    /// of the work items it references.
    ///
    /// - parameter flags: flags that control the execution environment of the
    /// - parameter qos: the QoS at which the work item should be executed.
    ///    Defaults to `DispatchQoS.unspecified`.
    /// - parameter flags: flags that control the execution environment of the
    /// work item.
    /// - parameter execute: The work item to be invoked on the queue.
    /// - SeeAlso: `sync(execute:)`
    /// - SeeAlso: `DispatchQoS`
    /// - SeeAlso: `DispatchWorkItemFlags`
    ///
    func async(
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    )

    ///
    /// Submits a block for synchronous execution on this queue.
    ///
    /// Submits a work item to a dispatch queue like `async(execute:)`, however
    /// `sync(execute:)` will not return until the work item has finished.
    ///
    /// Work items submitted to a queue with `sync(execute:)` do not observe certain
    /// queue attributes of that queue when invoked (such as autorelease frequency
    /// and QoS class).
    ///
    /// Calls to `sync(execute:)` targeting the current queue will result
    /// in deadlock. Use of `sync(execute:)` is also subject to the same
    /// multi-party deadlock problems that may result from the use of a mutex.
    /// Use of `async(execute:)` is preferred.
    ///
    /// As an optimization, `sync(execute:)` invokes the work item on the thread which
    /// submitted it, except when the queue is the main queue or
    /// a queue targetting it.
    ///
    /// - parameter execute: The work item to be invoked on the queue.
    /// - SeeAlso: `async(execute:)`
    ///
    func sync(execute block: () -> Void)

    /// Schedules a work item for immediate execution, and returns immediately.
    ///
    /// - Parameter execute: The work item containing the task to execute.
    /// For information on how to create this work item.
    func async(execute workItem: DispatchWorkItem)

    /// Submits a block for synchronous execution on this queue.
    ///
    /// - Parameter workItem: The work item to be invoked on the queue.
    func sync(execute workItem: DispatchWorkItem)
}

public extension IDispatchQueue {
    func asyncAfter(
        deadline: DispatchTime,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping @convention(block) () -> Void
    ) {
        asyncAfter(deadline: deadline, qos: qos, flags: flags, execute: work)
    }

    func async(execute work: @escaping @convention(block) () -> Void) {
        async(qos: .unspecified, flags: [], execute: work)
    }
}
