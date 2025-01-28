//
// Concurrency
// Copyright © 2025 Space Code. All rights reserved.
//

// MARK: - ITask

#if swift(>=6.0)
    /// A protocol representing a task that can be awaited until its execution completes.
    protocol ITask {
        /// Waits for the `Task` to complete by retrieving its result.
        func wait() async
    }

    // MARK: - Task + ITask

    /// Extends the `Task` type to conform to the `ITask` protocol.
    extension Task: ITask {
        func wait() async {
            _ = await result
        }
    }
#endif
