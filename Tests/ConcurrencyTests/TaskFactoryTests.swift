//
// Concurrency
// Copyright © 2026 Space Code. All rights reserved.
//

@testable import Concurrency
import TestConcurrency
import XCTest

#if swift(>=6.0)

    // MARK: - TaskFactoryTests

    final class TaskFactoryTests: XCTestCase {
        // MARK: Types

        private enum TestError: Error, Equatable {
            case failed
        }

        // MARK: Tests

        func testThatTaskFactoryKeepsTheTypeOfTheErrorOfATypedTask() async {
            // given
            let sut: ITaskFactory = TaskFactory()

            // when
            let task = sut.typedTask { () async throws(TestError) -> Int in throw .failed }
            let result = await task.result

            // then
            XCTAssertEqual(result, .failure(.failed))
        }

        func testThatTaskFactoryKeepsTheTypeOfTheErrorOfATypedDetachedTask() async {
            // given
            let sut: ITaskFactory = TaskFactory()

            // when
            let task = sut.typedDetached { () async throws(TestError) -> Int in throw .failed }
            let result = await task.result

            // then
            XCTAssertEqual(result, .failure(.failed))
        }

        func testThatTaskFactoryStillMakesUntypedAndNonThrowingTasks() async throws {
            // given
            let sut: ITaskFactory = TaskFactory()

            // when
            let throwing = sut.task { () async throws -> Int in 1 }
            let nonThrowing = sut.task { 2 }

            // then
            let first = try await throwing.value
            let second = await nonThrowing.value
            XCTAssertEqual(first, 1)
            XCTAssertEqual(second, 2)
        }

        func testThatTestTaskFactoryWaitsForTypedTasks() async {
            // given
            let sut = TestTaskFactory()
            let finished = Flag()

            // when
            _ = sut.typedTask { () async throws(TestError) in
                await Task.yield()
                finished.set()
            }
            await sut.waitUntilIdle()

            // then
            XCTAssertTrue(finished.isSet)
        }

        func testThatTestTaskFactoryWaitsForTypedDetachedTasks() async {
            // given
            let sut = TestTaskFactory()
            let finished = Flag()

            // when
            _ = sut.typedDetached { () async throws(TestError) in
                await Task.yield()
                finished.set()
            }
            await sut.waitUntilIdle()

            // then
            XCTAssertTrue(finished.isSet)
        }
    }

    // MARK: - Flag

    private final class Flag: @unchecked Sendable {
        private let lock = NSLock()
        private var value = false

        var isSet: Bool {
            lock.withLock { value }
        }

        func set() {
            lock.withLock { value = true }
        }
    }
#endif
