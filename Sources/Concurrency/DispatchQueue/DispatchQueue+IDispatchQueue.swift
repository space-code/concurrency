//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

extension DispatchQueue: IDispatchQueue {
    #if swift(>=5.9)
        public func async(
            qos: DispatchQoS,
            flags: DispatchWorkItemFlags,
            execute work: @escaping @Sendable @convention(block) () -> Void
        ) {
            async(group: nil, qos: qos, flags: flags, execute: work)
        }
    #else
        public func async(qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
            async(group: nil, qos: qos, flags: flags, execute: work)
        }
    #endif
}
