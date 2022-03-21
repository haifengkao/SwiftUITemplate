//
//  RequiredTargetTypes.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/2/3.
//

import Foundation

enum RequiredTargetType: Hashable {
    case framework
    case unitTests
    case exampleApp
    case uiTests
}

extension RequiredTargetType {
    /// unitTests's dependencies will include .framework's depdendencies
    /// we need this to workaround tuist needs to specify all swift package dependencies bug
    var associatedTargets: TargetTypes {
        switch self {
        case .framework:
            return .init([.framework])
        case .unitTests:
            return .init([.framework, .unitTests])
        case .exampleApp:
            return .init([.framework, .exampleApp])
        case .uiTests:
            return .init([.framework, .exampleApp, .uiTests])
        }
    }
}

typealias TargetTypes = Set<RequiredTargetType>

extension TargetTypes {
    static var all: Self = .init([.framework, .unitTests, .exampleApp, .uiTests])
}

/// manage target configs
struct RequiredTargetTypes: Hashable {
    let configs: [RequiredTargetType: TargetConfig]

    func contains(_ type: RequiredTargetType) -> Bool {
        configs.keys.contains(type)
    }

    func hasResources(_ type: RequiredTargetType) -> Bool {
        if let config = configs[type] {
            return config.hasResources
        }

        return false
    }

    func hasHeader(_ type: RequiredTargetType) -> Bool {
        configs[type]?.hasHeader ?? false
    }

    private func modules(_ type: RequiredTargetType) -> Modules {
        configs[type]?.modules ?? []
    }

    // static var deflautTargets: Self = .init(types: .defulatTargets, hasResources: .empty)
    // static var withExample: Self = .init(types: .withExample, hasResources: .empty)
    // static var withUItests: Self = .init(types: .withUItests, hasResources: .empty)
    // static var unitTestOnly: Self = .init(types: .unitTestOnly, hasResources: .empty)
    // static var frameworkResourcesAndUnitTest: Self = .init(types: .unitTestOnly, hasResources: [.framework])
    // static var unitTestWithResources: Self = .init(types: .unitTestOnly, hasResources: [.unitTests])

    /// we don't support objc unit test kiwi framework
    // static var objcTargets: Self = .init(types: .objcTargets, hasResources: .empty, hasHeader: true)
}

extension RequiredTargetTypes: HasModuleDependencies {
    /// return modules which is required by specified types
    func moduleDependencies(types: TargetTypes) -> Modules {
        let values: [Module] = types.reduce(into: []) { res, type in
            res = res + modules(type)
        }
        return .init(values)
    }
}

extension RequiredTargetTypes: PackageDependencyProviding {
    func packageDependencies(types: TargetTypes) -> SwiftPackages {
        SwiftPackages(moduleDependencies(types: types).compactMap(\.package))
    }
}

extension Set where Element == RequiredTargetType {
    /// uiTests is not enabled by default
    static var defulatTargets: Set<RequiredTargetType> = .unitTestOnly

    static var withExample: Set<RequiredTargetType> = [.framework, .unitTests, .exampleApp]

    static var withUItests: Set<RequiredTargetType> = [.framework, .unitTests, .exampleApp, .uiTests]
    static var unitTestOnly: Set<RequiredTargetType> = [.framework, .unitTests]

    /// we don't support objc unit test kiwi framework
    static var objcTargets: Set<RequiredTargetType> = [.framework]
    static var empty: Self = .init()
}
