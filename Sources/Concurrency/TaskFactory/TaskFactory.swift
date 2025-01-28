//
// Concurrency
// Copyright © 2025 Space Code. All rights reserved.
//

#if swift(>=6.0)
    public final class TaskFactory: ITaskFactory {
        // MARK: Initialization

        public init() {}

        // MARK: ITaskFactory

        // swiftlint:disable attributes
        public func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            Task(priority: priority, operation: operation)
        }

        public func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            Task(priority: priority, operation: operation)
        }

        public func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            Task.detached(priority: priority, operation: operation)
        }

        public func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            Task.detached(priority: priority, operation: operation)
        }
        // swiftlint:enable attributes
    }
#endif
