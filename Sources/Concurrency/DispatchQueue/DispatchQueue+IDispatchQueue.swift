//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

extension DispatchQueue: IDispatchQueue {
    public func async(qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: qos, flags: flags, execute: work)
    }
}
