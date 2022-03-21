//
//  HasReference.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/15.
//

import ProjectDescription

protocol HasReference {
    var reference: TargetDependency { get }
}

extension Module: HasReference {
    var reference: TargetDependency {
        switch self {
        case let .uFeature(microFeature):
            return microFeature.reference
        case let .package(swiftPackage):
            return swiftPackage.reference
        }
    }
}
