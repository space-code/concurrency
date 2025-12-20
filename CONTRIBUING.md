# Contributing to Concurrency

First off, thank you for considering contributing to Concurrency! It's people like you that make Concurrency such a great tool.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
  - [Development Setup](#development-setup)
  - [Project Structure](#project-structure)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Improving Documentation](#improving-documentation)
  - [Submitting Code](#submitting-code)
- [Development Workflow](#development-workflow)
  - [Branching Strategy](#branching-strategy)
  - [Commit Guidelines](#commit-guidelines)
  - [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
  - [Swift Style Guide](#swift-style-guide)
  - [Code Quality](#code-quality)
  - [Testing Requirements](#testing-requirements)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to nv3212@gmail.com.

## Getting Started

### Development Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/concurrency.git
   cd concurrency
   ```

3. **Set up the development environment**
   ```bash
   # Bootstrap the project
   make bootstrap
   ```

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Open the project in Xcode**
   ```bash
   open Package.swift
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report, please check the [existing issues](https://github.com/space-code/concurrency/issues) to avoid duplicates.

When creating a bug report, include:

- **Clear title** - Describe the issue concisely
- **Reproduction steps** - Detailed steps to reproduce the bug
- **Expected behavior** - What you expected to happen
- **Actual behavior** - What actually happened
- **Environment** - OS, Xcode version, Swift version
- **Code samples** - Minimal reproducible example
- **Error messages** - Complete error output if applicable

**Example:**
```markdown
**Title:** TestDispatchQueue does not execute blocks synchronously

**Steps to reproduce:**
1. Create TestDispatchQueue instance
2. Call async with a block that modifies state
3. Check state immediately after async call

**Expected:** Block should execute immediately
**Actual:** Block is queued for later execution

**Environment:**
- macOS 14.0
- Xcode 15.3
- Swift 5.10

**Code:**
\`\`\`swift
let testQueue = TestDispatchQueue()
var value = 0
testQueue.async {
    value = 42
}
print(value) // Expected: 42, Actual: 0
\`\`\`
```

### Suggesting Features

We love feature suggestions! When proposing a new feature, include:

- **Problem statement** - What problem does this solve?
- **Proposed solution** - How should it work?
- **Alternatives** - What alternatives did you consider?
- **Use cases** - Real-world scenarios
- **API design** - Example code showing usage
- **Breaking changes** - Will this break existing code?

**Example:**
```markdown
**Feature:** Add barrier support for concurrent queues

**Problem:** Users need to synchronize writes in concurrent queue contexts while maintaining read parallelism.

**Solution:** Add barrier methods to IDispatchQueue protocol.

**API:**
\`\`\`swift
protocol IDispatchQueue {
    func async(flags: DispatchWorkItemFlags, execute work: @escaping () -> Void)
    func asyncBarrier(execute work: @escaping () -> Void)
}
\`\`\`

**Use case:** Thread-safe cache that allows concurrent reads but exclusive writes:
\`\`\`swift
class Cache {
    private let queue: IDispatchQueue
    
    func read() {
        queue.async { /* read operation */ }
    }
    
    func write() {
        queue.asyncBarrier { /* write operation */ }
    }
}
\`\`\`
```

### Improving Documentation

Documentation improvements are always welcome:

- **Code comments** - Add/improve inline documentation
- **DocC documentation** - Enhance documentation articles
- **README** - Fix typos, add examples
- **Guides** - Write tutorials or how-to guides
- **API documentation** - Document public APIs

### Submitting Code

1. **Check existing work** - Look for related issues or PRs
2. **Discuss major changes** - Open an issue for large features
3. **Follow coding standards** - See [Coding Standards](#coding-standards)
4. **Write tests** - All code changes require tests
5. **Update documentation** - Keep docs in sync with code
6. **Create a pull request** - Use clear description

## Development Workflow

### Branching Strategy

We use a simplified branching model:

- **`main`** - Main development branch (all PRs target this)
- **`feature/*`** - New features
- **`fix/*`** - Bug fixes
- **`docs/*`** - Documentation updates
- **`refactor/*`** - Code refactoring
- **`test/*`** - Test improvements

**Branch naming examples:**
```bash
feature/add-barrier-support
fix/test-queue-synchronization
docs/update-testing-guide
refactor/simplify-queue-factory
test/add-concurrent-queue-tests
```

### Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear, structured commit history.

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style (formatting, no logic changes)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks
- `perf` - Performance improvements

**Scopes:**
- `factory` - DispatchQueueFactory
- `protocol` - IDispatchQueue protocol
- `test` - TestConcurrency target
- `queue` - Queue implementations
- `deps` - Dependencies

**Examples:**
```bash
feat(factory): add support for dispatch queue with target

Allow users to specify target queue when creating private queues.
This enables hierarchical queue setups for better resource management.

Closes #23

---

fix(test): ensure TestDispatchQueue executes blocks immediately

TestDispatchQueue was queuing blocks instead of executing them
synchronously, breaking the test double contract. Now properly
executes blocks immediately in the same call stack.

Fixes #45

---

docs(readme): add thread-safe property access example

Add practical example showing how to use serial queues for
thread-safe access to shared mutable state.

---

test(factory): add tests for quality of service configurations

Add tests for:
- All QoS levels
- QoS propagation to created queues
- Default QoS behavior
```

**Commit message rules:**
- Use imperative mood ("add" not "added")
- Don't capitalize first letter
- No period at the end
- Keep subject line under 72 characters
- Separate subject from body with blank line
- Reference issues in footer

### Pull Request Process

1. **Update your branch**
   ```bash
   git checkout main
   git pull upstream main
   git checkout feature/your-feature
   git rebase main
   ```

2. **Run tests and checks**
   ```bash
   # Run all tests
   swift test
   
   # Check test coverage
   swift test --enable-code-coverage
   
   # Run tests for both targets
   swift test --filter ConcurrencyTests
   swift test --filter TestConcurrencyTests
   ```

3. **Push to your fork**
   ```bash
   git push origin feature/your-feature
   ```

4. **Create pull request**
   - Target the `main` branch
   - Provide clear description
   - Link related issues
   - Include examples if applicable
   - Request review from maintainers

5. **Review process**
   - Address review comments
   - Keep PR up to date with main
   - Squash commits if requested
   - Wait for CI to pass

6. **After merge**
   ```bash
   # Clean up local branch
   git checkout main
   git pull upstream main
   git branch -d feature/your-feature
   
   # Clean up remote branch
   git push origin --delete feature/your-feature
   ```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide).

**Key points:**

1. **Naming**
   ```swift
   // ✅ Good
   func async(execute work: @escaping () -> Void)
   let mainQueue: IDispatchQueue
   
   // ❌ Bad
   func doAsync(_ w: @escaping () -> Void)
   let q: IDispatchQueue
   ```

2. **Protocols**
   ```swift
   // ✅ Good - Use "I" prefix for protocols
   protocol IDispatchQueue {
       func async(execute work: @escaping () -> Void)
   }
   
   // ❌ Bad
   protocol DispatchQueue { }
   ```

3. **Access Control**
   ```swift
   // ✅ Good - Explicit access control
   public final class DispatchQueueFactory: IDispatchQueueFactory {
       public init() {}
       
       public func main() -> IDispatchQueue {
           return DispatchQueue.main
       }
       
       public func global(qos: DispatchQoS.QoSClass) -> IDispatchQueue {
           return DispatchQueue.global(qos: qos)
       }
   }
   ```

4. **Documentation**
   ```swift
   /// Creates a new dispatch queue with custom configuration.
   ///
   /// This method allows fine-grained control over queue behavior including
   /// quality of service, serial vs concurrent execution, and memory management.
   ///
   /// - Parameters:
   ///   - label: A unique identifier for the queue, useful for debugging
   ///   - qos: The quality of service class for work items
   ///   - attributes: Queue attributes (empty for serial, .concurrent for concurrent)
   ///   - autoreleaseFrequency: How often to drain the autorelease pool
   ///   - target: The target queue on which to execute blocks
   /// - Returns: A new dispatch queue configured with the specified parameters
   ///
   /// - Example:
   /// ```swift
   /// let queue = factory.privateQueue(
   ///     label: "com.example.myqueue",
   ///     qos: .userInitiated,
   ///     attributes: .concurrent
   /// )
   /// ```
   public func privateQueue(
       label: String,
       qos: DispatchQoS,
       attributes: DispatchQueue.Attributes,
       autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency,
       target: DispatchQueue?
   ) -> IDispatchQueue {
       // Implementation
   }
   ```

### Code Quality

- **No force unwrapping** - Use optional binding or guards
- **No force casting** - Use conditional casting
- **No magic numbers** - Use named constants
- **Single responsibility** - One class, one purpose
- **DRY principle** - Don't repeat yourself
- **SOLID principles** - Follow SOLID design
- **Protocol-oriented** - Favor protocols over concrete types

**Example:**
```swift
// ✅ Good
public protocol IDispatchQueueFactory {
    func main() -> IDispatchQueue
    func global(qos: DispatchQoS.QoSClass) -> IDispatchQueue
}

public final class DispatchQueueFactory: IDispatchQueueFactory {
    public init() {}
    
    public func main() -> IDispatchQueue {
        DispatchQueue.main
    }
    
    public func global(qos: DispatchQoS.QoSClass) -> IDispatchQueue {
        DispatchQueue.global(qos: qos)
    }
}

// ❌ Bad
public class QueueFactory {
    func getQueue(type: String, qos: Int?) -> Any {
        if type == "main" {
            return DispatchQueue.main
        }
        return DispatchQueue.global(qos: DispatchQoS.QoSClass(rawValue: qos!)!)
    }
}
```

### Testing Requirements

All code changes must include tests:

1. **Unit tests** - Test individual components
2. **Integration tests** - Test component interactions
3. **Test double verification** - Ensure TestConcurrency works correctly
4. **Edge cases** - Test boundary conditions
5. **Thread safety** - Test concurrent access patterns

**Coverage requirements:**
- New code: minimum 80% coverage
- Modified code: maintain or improve existing coverage
- Critical paths: 100% coverage

**Test structure:**
```swift
import XCTest
@testable import Concurrency

final class DispatchQueueFactoryTests: XCTestCase {
    var sut: DispatchQueueFactory!
    
    override func setUp() {
        super.setUp()
        sut = DispatchQueueFactory()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Main Queue Tests
    
    func test_thatMainReturnsMainQueue_whenCalled() {
        // When
        let queue = sut.main()
        
        // Then
        XCTAssertTrue(queue is DispatchQueue)
    }
    
    // MARK: - Global Queue Tests
    
    func test_thatGlobalReturnsQueueWithCorrectQoS_whenUserInitiatedQoSProvided() {
        // When
        let queue = sut.global(qos: .userInitiated)
        
        // Then
        XCTAssertTrue(queue is DispatchQueue)
    }
    
    // MARK: - Private Queue Tests
    
    func test_thatPrivateQueueCreatesSerialQueue_whenSerialAttributesProvided() {
        // Given
        let label = "com.test.serial"
        
        // When
        let queue = sut.privateQueue(
            label: label,
            qos: .default,
            attributes: [],
            autoreleaseFrequency: .inherit,
            target: nil
        )
        
        // Then
        XCTAssertTrue(queue is DispatchQueue)
    }
    
    func test_thatPrivateQueueCreatesConcurrentQueue_whenConcurrentAttributesProvided() {
        // Given
        let label = "com.test.concurrent"
        
        // When
        let queue = sut.privateQueue(
            label: label,
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil
        )
        
        // Then
        XCTAssertTrue(queue is DispatchQueue)
    }
}
```

## Community

- **Discussions** - Join [GitHub Discussions](https://github.com/space-code/concurrency/discussions)
- **Issues** - Track [open issues](https://github.com/space-code/concurrency/issues)
- **Pull Requests** - Review [open PRs](https://github.com/space-code/concurrency/pulls)

## Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes
- Project README (for significant contributions)

## Questions?

- Check [existing issues](https://github.com/space-code/concurrency/issues)
- Search [discussions](https://github.com/space-code/concurrency/discussions)
- Ask in [Q&A discussions](https://github.com/space-code/concurrency/discussions/categories/q-a)
- Email the maintainer: nv3212@gmail.com

---

Thank you for contributing to Concurrency! 🎉

Your efforts help make this project better for everyone.