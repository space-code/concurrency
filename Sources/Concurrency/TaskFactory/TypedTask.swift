//
// Concurrency
// Copyright © 2026 Space Code. All rights reserved.
//

#if swift(>=6.0)

    // MARK: - TypedTask

    /// A unit of asynchronous work that fails with a specific type of error.
    ///
    /// The standard library only creates a `Task` that fails with `Never` or `any Error`, so a task whose operation
    /// `throws(MyError)` loses its error type. `TypedTask` keeps it: awaiting ``value`` throws `Failure`, and
    /// ``result`` is a `Result<Success, Failure>`.
    ///
    /// ```swift
    /// let task = TypedTask { () async throws(NetworkError) -> User in
    ///     try await client.loadUser()
    /// }
    ///
    /// do throws(NetworkError) {
    ///     let user = try await task.value
    /// } catch {
    ///     // `error` is a `NetworkError`.
    /// }
    /// ```
    ///
    /// Cancelling a `TypedTask` cancels the work like cancelling a `Task` does: it only sets a flag that the operation
    /// reads, and the operation decides whether to fail.
    public struct TypedTask<Success: Sendable, Failure: Error>: Sendable, Hashable {
        // MARK: Properties

        private let task: Task<Result<Success, Failure>, Never>

        // MARK: Initialization

        /// Runs the operation in a new task that inherits the actor context of the caller.
        ///
        /// - Parameters:
        ///   - priority: The priority of the task. Pass `nil` to inherit the priority of the caller.
        ///   - operation: The operation to run. It can only fail with `Failure`.
        public init(
            priority: TaskPriority? = nil,
            @_inheritActorContext operation: sending @escaping @isolated(any) () async throws(Failure) -> Success
        ) {
            task = Task(priority: priority) {
                await Self.run(operation)
            }
        }

        private init(task: Task<Result<Success, Failure>, Never>) {
            self.task = task
        }

        // MARK: Interface

        /// The success value of the task, or the error it failed with.
        ///
        /// Waiting for the value does not cancel the task when the waiting code is cancelled.
        public var value: Success {
            get async throws(Failure) {
                try await task.value.get()
            }
        }

        /// The outcome of the task, once it has finished.
        public var result: Result<Success, Failure> {
            get async {
                await task.value
            }
        }

        /// Whether the task was cancelled.
        public var isCancelled: Bool {
            task.isCancelled
        }

        /// Runs the operation in a new task that does not inherit the actor context of the caller.
        ///
        /// - Parameters:
        ///   - priority: The priority of the task. Pass `nil` to use the default priority.
        ///   - operation: The operation to run. It can only fail with `Failure`.
        /// - Returns: The task that runs the operation.
        public static func detached(
            priority: TaskPriority? = nil,
            operation: sending @escaping @isolated(any) () async throws(Failure) -> Success
        ) -> TypedTask {
            TypedTask(task: Task.detached(priority: priority) {
                await run(operation)
            })
        }

        /// Cancels the task.
        public func cancel() {
            task.cancel()
        }

        // MARK: Private

        private static func run(
            _ operation: @isolated(any) () async throws(Failure) -> Success
        ) async -> Result<Success, Failure> {
            do throws(Failure) {
                return try await .success(operation())
            } catch {
                return .failure(error)
            }
        }
    }
#endif
