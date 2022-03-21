//
//  PackageDependencyProviding.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/11.
//

import Foundation

protocol PackageDependencyProviding {
    func packageDependencies(types: TargetTypes) -> SwiftPackages
}

extension MicroFeature: PackageDependencyProviding {
    func packageDependencies(types: TargetTypes) -> SwiftPackages {
        requiredTargetTypes.packageDependencies(types: types)
    }
}

extension Module: PackageDependencyProviding {
    func packageDependencies(types: TargetTypes) -> SwiftPackages {
        switch self {
        case let .uFeature(microFeature):
            return microFeature.packageDependencies(types: types)
        case let .package(swiftPackage):
            return [swiftPackage]
        }
    }
}

import ProjectDescription
extension PackageDependencyProviding {
    func packages(types: TargetTypes) -> [Package] {
        packageDependencies(types: types).map(\.package)
    }
}
