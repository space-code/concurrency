//
// Concurrency
// Copyright © 2025 Space Code. All rights reserved.
//

import Concurrency
import Foundation

// MARK: - TestTaskFactory

public final class TestTaskFactory: @unchecked Sendable {
    // MARK: Properties

    private let lock = NSLock()
    private var tasks: [ITask] = []

    // MARK: Intialization

    public init() {}

    // MARK: Public

    /// Waits until all tasks in the queue have completed execution.
    public func waitUntilIdle() async {
        while let task = popTask() {
            await task.wait()
        }
    }

    // MARK: Private

    private func addTask(_ task: ITask) {
        lock.lock()
        defer { lock.unlock() }
        tasks.append(task)
    }

    private func popTask() -> ITask? {
        lock.lock()
        defer { lock.unlock() }
        return tasks.popLast()
    }
}

// MARK: ITaskFactory

extension TestTaskFactory: ITaskFactory {
    public func task<Success: Sendable>(
        priority: TaskPriority?,
        @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
    ) -> Task<Success, Error> {
        let task = Task(priority: priority, operation: operation)
        addTask(task)
        return task
    }

    public func task<Success: Sendable>(
        priority: TaskPriority?,
        @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
    ) -> Task<Success, Never> {
        let task = Task(priority: priority, operation: operation)
        addTask(task)
        return task
    }

    public func detached<Success: Sendable>(
        priority: TaskPriority?,
        @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
    ) -> Task<Success, Error> {
        let task = Task.detached(priority: priority, operation: operation)
        addTask(task)
        return task
    }

    public func detached<Success: Sendable>(
        priority: TaskPriority?,
        @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
    ) -> Task<Success, Never> {
        let task = Task.detached(priority: priority, operation: operation)
        addTask(task)
        return task
    }
}
