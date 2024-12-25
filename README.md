![concurrency: A collection of concurrency primitives](https://raw.githubusercontent.com/space-code/concurrency/dev/Resources/concurrency.png)

<h1 align="center" style="margin-top: 0px;">concurrency</h1>

<p align="center">
<a href="https://github.com/space-code/concurrency/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/concurrency?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-%23989898"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift5.5" src="https://img.shields.io/badge/language-Swift5.5-orange.svg"/></a>
<a href="https://github.com/space-code/concurrency"><img alt="CI" src="https://github.com/space-code/concurrency/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/apple/swift-package-manager" alt="RxSwift on Swift Package Manager" title="RxSwift on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>

## Description
`concurrency` is a collection of concurrency primitives which helps increase testability

- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Usage

```swift
import Concurrency

// Create `DispatchQueueFactory` instance
let factory = DispatchQueueFactory()

// Build `main` queue from factory
let mainQueue = factory.main()

// Build `global` queue with QOS
let globalQueue = factory.global(qos: .background)

// Build `private` queue
let privateQueue = factory.privateQueue(label: String(describing: self),
                                        qos: .background,
                                        attributes: .concurrent,
                                        autoreleaseFrequency: .inherit,
                                        target: nil)
```

For testing purposes, you can use `TestConrurrency` target.

```swift
import TestConcurrency

let testQueue = TestDispatchQueue()

// Run block immediately
testQueue.async {}
```

## Requirements
- iOS 13.0+ / macOS 10.15+ / tvOS 12.0+ / watchOS 6.0+
- Xcode 14.0
- Swift 5.5

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `concurrency` does support its use on supported platforms.

Once you have your Swift package set up, adding `concurrency` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/space-code/concurrency.git", .upToNextMajor(from: "0.1.0"))
]
```

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Contributing
Bootstrapping development environment

```
make bootstrap
```

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request!

## Author
Nikita Vasilev, nv3212@gmail.com

## License
concurrency is available under the MIT license. See the LICENSE file for more info.
