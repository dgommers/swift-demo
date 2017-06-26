//  Copyright © 2017 Derk Gommers. All rights reserved.

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    func element(at index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
