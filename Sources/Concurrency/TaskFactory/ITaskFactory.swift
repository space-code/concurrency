//
// Concurrency
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation

#if swift(>=6.0)

    // MARK: - ITaskFactory

    // swiftlint:disable attributes
    /// A protocol for creating and managing tasks with different configurations.
    /// Provides methods to create tasks tied to the current actor context or detached tasks
    /// that run independently of the current actor.
    public protocol ITaskFactory {
        /// Creates a task tied to the current actor context that can throw errors.
        /// - Parameters:
        ///   - priority: The priority of the task (optional).
        ///   - operation: An asynchronous operation to execute within the task. The operation
        ///     inherits the current actor context and is isolated to that actor.
        /// - Returns: A `Task` object that wraps the result or error of the operation.
        func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error>

        /// Creates a task tied to the current actor context that does not throw errors.
        /// - Parameters:
        ///   - priority: The priority of the task (optional).
        ///   - operation: An asynchronous operation to execute within the task. The operation
        ///     inherits the current actor context and is isolated to that actor.
        /// - Returns: A `Task` object that wraps the result of the operation.
        func task<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never>

        /// Creates a detached task that runs independently of the current actor context
        /// and can throw errors.
        /// - Parameters:
        ///   - priority: The priority of the task (optional).
        ///   - operation: An asynchronous operation to execute within the task. The operation
        ///     is isolated and does not inherit the current actor context.
        /// - Returns: A `Task` object that wraps the result or error of the operation.
        func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error>

        /// Creates a detached task that runs independently of the current actor context
        /// and does not throw errors.
        /// - Parameters:
        ///   - priority: The priority of the task (optional).
        ///   - operation: An asynchronous operation to execute within the task. The operation
        ///     is isolated and does not inherit the current actor context.
        /// - Returns: A `Task` object that wraps the result of the operation.
        func detached<Success: Sendable>(
            priority: TaskPriority?,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never>
    }

    /// Default implementations for the `ITaskFactory` protocol.
    public extension ITaskFactory {
        /// Creates a task tied to the current actor context with a default priority
        /// that can throw errors.
        /// - Parameter operation: An asynchronous operation to execute within the task.
        /// - Returns: A `Task` object that wraps the result or error of the operation.
        func task<Success: Sendable>(
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            task(priority: nil, operation: operation)
        }

        /// Creates a task tied to the current actor context with a default priority
        /// that does not throw errors.
        /// - Parameter operation: An asynchronous operation to execute within the task.
        /// - Returns: A `Task` object that wraps the result of the operation.
        func task<Success: Sendable>(
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            task(priority: nil, operation: operation)
        }

        /// Creates a detached task with a default priority that runs independently
        /// of the current actor context and can throw errors.
        /// - Parameter operation: An asynchronous operation to execute within the task.
        /// - Returns: A `Task` object that wraps the result or error of the operation.
        func detached<Success: Sendable>(
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws -> Success
        ) -> Task<Success, Error> {
            detached(priority: nil, operation: operation)
        }

        /// Creates a detached task with a default priority that runs independently
        /// of the current actor context and does not throw errors.
        /// - Parameter operation: An asynchronous operation to execute within the task.
        /// - Returns: A `Task` object that wraps the result of the operation.
        func detached<Success: Sendable>(
            @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
        ) -> Task<Success, Never> {
            detached(priority: nil, operation: operation)
        }
    }

    // swiftlint:enable attributes
#endif
