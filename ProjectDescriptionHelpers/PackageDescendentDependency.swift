//
//  PackageDescendentDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/11.
//

import Foundation

protocol PackageDescendentDependencyProviding: PackageDependencyProviding {
    func packageDescendentDependencies(types: TargetTypes) -> SwiftPackages
}

extension MicroFeature: PackageDescendentDependencyProviding {
    func packageDescendentDependencies(types: TargetTypes) -> SwiftPackages {
        let associatedTargets: TargetTypes = .init(types.map(\.associatedTargets).joined())

        let directSwiftPackages: SwiftPackages = packageDependencies(types: associatedTargets)

        let indirectSwiftPackages = moduleDependencies(types: associatedTargets).map { (m: Module) -> SwiftPackages in
            let types: TargetTypes = [.framework]

            return m.packageDescendentDependencies(types: types)
        }.joined()

        return directSwiftPackages.union(SwiftPackages(indirectSwiftPackages))
    }
}

extension Module: PackageDescendentDependencyProviding {
    func packageDescendentDependencies(types: TargetTypes) -> SwiftPackages {
        switch self {
        case let .uFeature(microFeature):
            return microFeature.packageDescendentDependencies(types: types)
        case let .package(swiftPackage):
            return [swiftPackage]
        }
    }
}
