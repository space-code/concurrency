![concurrency: A collection of concurrency primitives](./Resources/concurrency.png)

<h1 align="center" style="margin-top: 0px;">concurrency</h1>

<p align="center">
<a href="https://github.com/space-code/concurrency/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/concurrency?style=flat"></a> 
<a href="https://swiftpackageindex.com/space-code/concurrency"><img alt="Swift Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fconcurrency%2Fbadge%3Ftype%3Dswift-versions"></a>
<a href="https://swiftpackageindex.com/space-code/concurrency"><img alt="Platform Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fconcurrency%2Fbadge%3Ftype%3Dplatforms"/></a> 
<a href="https://github.com/space-code/concurrency/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/space-code/concurrency/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/apple/swift-package-manager" alt="concurrency on Swift Package Manager" title="concurrency on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>

## Description

`concurrency` is a modern, testable Swift framework that provides elegant abstractions for Grand Central Dispatch (GCD) primitives. Built with testability in mind, it enables you to write concurrent code that's easy to test and maintain.

## Features
✨ **Type-Safe Queue Abstractions** - Clean interfaces for main, global, and custom queues  
🧪 **Built for Testing** - Comes with dedicated test doubles for unit testing  
⚡ **Lightweight** - Minimal wrapper around GCD with zero overhead  
🎯 **Protocol-Based** - Easy to mock and inject dependencies  
📱 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS, and visionOS  

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Dispatch Queue Factory](#dispatch-queue-factory)
  - [Main Queue](#main-queue)
  - [Global Queue](#global-queue)
  - [Private Queue](#private-queue)
  - [Testing](#testing)
- [Communication](#communication)
- [Contributing](#contributing)
  - [Development Setup](#development-setup)
- [Author](#author)
- [License](#license)

## Requirements

| Platform  | Minimum Version |
|-----------|----------------|
| iOS       | 13.0+          |
| macOS     | 10.15+         |
| tvOS      | 13.0+          |
| watchOS   | 6.0+           |
| visionOS  | 1.0+           |
| Xcode     | 15.3+          |
| Swift     | 5.10+          |

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/space-code/concurrency.git", from: "0.2.0")
]
```

Or add it through Xcode:

1. File > Add Package Dependencies
2. Enter package URL: `https://github.com/space-code/concurrency.git`
3. Select version requirements

## Quick Start

```swift
import Concurrency

// Create a queue factory
let factory = DispatchQueueFactory()

// Use the main queue for UI updates
let mainQueue = factory.main()
mainQueue.async {
    // Update UI safely
    updateLabel()
}

// Use a background queue for heavy work
let backgroundQueue = factory.global(qos: .background)
backgroundQueue.async {
    processLargeDataset()
}
```

## Usage

### Dispatch Queue Factory

The DispatchQueueFactory is your entry point for creating all types of dispatch queues:

```swift
import Concurrency

let factory = DispatchQueueFactory()
```

### Main Queue

Perfect for UI updates and ensuring code runs on the main thread:

```swift
import Concurrency

class ViewController {
    private let factory = DispatchQueueFactory()
    private lazy var mainQueue = factory.main()
    
    func updateUI(with data: Data) {
        mainQueue.async {
            self.label.text = String(data: data, encoding: .utf8)
            self.refreshButton.isEnabled = true
        }
    }
}
```

### Global Queue

Access system-provided concurrent queues with different quality of service levels:

```swift
import Concurrency

class DataProcessor {
    private let factory = DispatchQueueFactory()
    
    func processInBackground() {
        // High priority background work
        let userInitiatedQueue = factory.global(qos: .userInitiated)
        userInitiatedQueue.async {
            self.performCriticalProcessing()
        }
        
        // Low priority background work
        let backgroundQueue = factory.global(qos: .background)
        backgroundQueue.async {
            self.performMaintenanceTasks()
        }
    }
}
```

**Quality of Service Levels:**

- `.userInteractive` - Work that is interacting with the user (animations, event handling)  
- `.userInitiated` - Work initiated by the user that prevents further interaction  
- `.default` - Default priority for work  
- `.utility` - Long-running tasks with user-visible progress  
- `.background` - Work not visible to the user (prefetching, maintenance)  
- `.unspecified` - Absence of QoS information`  

### Private Queue

Create custom queues with fine-grained control:

```swift
import Concurrency

class NetworkManager {
    private let factory = DispatchQueueFactory()
    
    // Serial queue for thread-safe access
    private lazy var serialQueue = factory.privateQueue(
        label: "com.example.network.serial",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .inherit,
        target: nil
    )
    
    // Concurrent queue for parallel processing
    private lazy var concurrentQueue = factory.privateQueue(
        label: "com.example.network.concurrent",
        qos: .utility,
        attributes: .concurrent,
        autoreleaseFrequency: .workItem,
        target: nil
    )
    
    func processRequests(_ requests: [Request]) {
        concurrentQueue.async {
            requests.forEach { request in
                self.process(request)
            }
        }
    }
}
```

**Parameters**:

- `label` - Unique identifier for debugging  
- `qos` - Quality of service class  
- `attributes` - .concurrent for concurrent execution, empty for serial  
- `autoreleaseFrequency` - Memory management strategy  
- `target` - Queue to execute blocks on (advanced usage)  

## Testing

Concurrency includes a dedicated test target with synchronous test doubles:

```swift
import TestConcurrency
import XCTest

class ViewModelTests: XCTestCase {
    func testDataFetching() {
        // Create test queue that executes immediately
        let testQueue = TestDispatchQueue()
        let viewModel = ViewModel(queue: testQueue)
        
        // Runs block immediately
        testQueue.async {}

        // No need for expectations - execution is synchronous
        viewModel.fetchData()
        
        // Assert immediately
        XCTAssertTrue(viewModel.isLoading)
    }
}
```

**Injecting Queues for Testability:**

```swift
import Concurrency

protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
    func sync(execute work: () -> Void)
}

extension DispatchQueue: DispatchQueueType {}

class DataManager {
    private let factory: IDispatchQueueFactory
    
    init(factory: IDispatchQueueFactory) {
        self.factory = factory
    }
    
    func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
        factory.global(qos: .background).async {
            // Perform work
            let result = self.fetchData()
            completion(result)
        }
    }
}
```

## Communication

- 🐛 **Found a bug?** [Open an issue](https://github.com/space-code/concurrency/issues/new)
- 💡 **Have a feature request?** [Open an issue](https://github.com/space-code/concurrency/issues/new)
- ❓ **Questions?** [Start a discussion](https://github.com/space-code/concurrency/discussions)
- 🔒 **Security issue?** Email nv3212@gmail.com

## Contributing

We love contributions! Please feel free to help out with this project. If you see something that could be made better or want a new feature, open up an issue or send a Pull Request.

### Development Setup

Bootstrap the development environment:

```bash
mise install
```

## Author

**Nikita Vasilev**
- Email: nv3212@gmail.com
- GitHub: [@ns-vasilev](https://github.com/ns-vasilev)

## License

Concurrency is released under the MIT license. See [LICENSE](https://github.com/space-code/concurrency/blob/main/LICENSE) for details.

---

<div align="center">

**[⬆ back to top](#concurrency)**

Made with ❤️ by [space-code](https://github.com/space-code)

</div>