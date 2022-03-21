//
//  SwiftPackage.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/4.
//

import ProjectDescription

public typealias SwiftPackages = Set<SwiftPackage>
/// swift package
public struct SwiftPackage: HasSwiftPackage, HasReference, Hashable {
    let name: String
    let url: String
    let requirement: Package.Requirement
    var package: Package { .remote(url: url, requirement: requirement) }
    var reference: TargetDependency {
        .package(product: name)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}
