//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

@testable import Concurrency
import XCTest

private extension String {
    static let label = "test_label"
}

// MARK: - DispatchQueueFactoryTests

final class DispatchQueueFactoryTests: XCTestCase {
    // MARK: Properties

    private var dispatchQueueFactory: DispatchQueueFactory!

    // MARK: XCTestCase

    override func setUp() {
        super.setUp()
        dispatchQueueFactory = DispatchQueueFactory()
    }

    override func tearDown() {
        dispatchQueueFactory = nil
        super.tearDown()
    }

    // MARK: Tests

    func testThatDispatchQueueInitializeMainQueue() {
        // given
        let mainQueue = DispatchQueue.main

        // when
        let queue = dispatchQueueFactory.main()

        // then
        XCTAssertTrue(mainQueue === queue)
    }

    func testThatDispatchQueueFactoryInitializeGlobalQueue() {
        // given
        let globalQueue = DispatchQueue.global(qos: .default)

        // when
        let queue = dispatchQueueFactory.global(qos: .default)

        // then
        XCTAssertTrue(globalQueue === queue)
    }

    func testThatDispatchQueueFactoryInitializePrivateQueue() throws {
        // given
        let privateQueue = dispatchQueueFactory.privateQueue(
            label: .label,
            qos: .userInteractive,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil
        )

        // then
        let queue = try XCTUnwrap(privateQueue as? DispatchQueue)
        XCTAssertEqual(queue.label, .label)
        XCTAssertEqual(queue.qos, .userInteractive)
    }
}
