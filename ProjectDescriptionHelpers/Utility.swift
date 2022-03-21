//
//  Utility.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/16.
//

import Foundation

public extension Array {
    func uniques<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> Self {
        var buffer = Array()
        var added = Set<Key>()
        for elem in self {
            if !added.contains(elem[keyPath: keyPath]) {
                buffer.append(elem)
                added.insert(elem[keyPath: keyPath])
            }
        }
        return buffer
    }
}

public extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

public extension Array where Element: Equatable {
    var uniquesByEquality: Array {
        var buffer = Array()
        var added: [Element] = []
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.append(elem)
            }
        }
        return buffer
    }
}
