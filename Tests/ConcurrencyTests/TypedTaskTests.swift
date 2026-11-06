//
// Concurrency
// Copyright © 2026 Space Code. All rights reserved.
//

@testable import Concurrency
import XCTest

#if swift(>=6.0)

    // MARK: - TypedTaskTests

    final class TypedTaskTests: XCTestCase {
        // MARK: Types

        private enum TestError: Error, Equatable {
            case failed
        }

        // MARK: Tests

        func testThatTypedTaskReturnsTheValueOfTheOperation() async throws {
            // given
            let sut = TypedTask { () async throws(TestError) -> Int in 42 }

            // when
            let value = try await sut.value

            // then
            XCTAssertEqual(value, 42)
        }

        func testThatTypedTaskThrowsTheTypedErrorOfTheOperation() async {
            // given
            let sut = TypedTask { () async throws(TestError) -> Int in throw .failed }

            // when
            var thrown: TestError?
            do throws(TestError) {
                _ = try await sut.value
            } catch {
                thrown = error
            }

            // then
            XCTAssertEqual(thrown, .failed)
        }

        func testThatTypedTaskResultKeepsTheTypeOfTheError() async {
            // given
            let sut = TypedTask { () async throws(TestError) -> Int in throw .failed }

            // when
            let result: Result<Int, TestError> = await sut.result

            // then
            XCTAssertEqual(result, .failure(.failed))
        }

        func testThatTypedTaskRunsTheOperationDetached() async throws {
            // given
            let sut = TypedTask<String, TestError>.detached { "detached" }

            // when
            let value = try await sut.value

            // then
            XCTAssertEqual(value, "detached")
        }

        func testThatTypedTaskReportsCancellation() async {
            // given
            let sut = TypedTask { () async throws(TestError) -> Bool in
                while !Task.isCancelled {
                    await Task.yield()
                }
                return Task.isCancelled
            }

            // when
            sut.cancel()
            let wasCancelled = await (sut.result.success ?? false)

            // then
            XCTAssertTrue(sut.isCancelled)
            XCTAssertTrue(wasCancelled)
        }

        func testThatEqualTypedTasksAreTheSameTask() {
            // given
            let first = TypedTask { () async throws(TestError) -> Int in 1 }
            let second = TypedTask { () async throws(TestError) -> Int in 1 }

            // then
            XCTAssertEqual(first, first)
            XCTAssertNotEqual(first, second)
        }
    }

    private extension Result {
        var success: Success? {
            try? get()
        }
    }
#endif
