//
// Concurrency
// Copyright © 2025 Space Code. All rights reserved.
//

#if swift(>=6.0)
    public final class TaskFactory: ITaskFactory {
        // MARK: Initialization

        public init() {}

        // MARK: ITaskFactory

        @discardableResult
        public func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            Task(priority: priority, operation: operation)
        }

        @discardableResult
        public func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            Task(priority: priority, operation: operation)
        }

        @discardableResult
        public func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            Task.detached(priority: priority, operation: operation)
        }

        @discardableResult
        public func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            Task.detached(priority: priority, operation: operation)
        }

        @discardableResult
        public func typedTask<Success: Sendable, Failure: Error>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws(Failure) -> Success
        ) -> TypedTask<Success, Failure> {
            TypedTask(priority: priority, operation: operation)
        }

        @discardableResult
        public func typedDetached<Success: Sendable, Failure: Error>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws(Failure) -> Success
        ) -> TypedTask<Success, Failure> {
            TypedTask.detached(priority: priority, operation: operation)
        }
    }
#endif
