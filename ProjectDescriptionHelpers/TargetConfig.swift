//
//  TargetConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/2/3.
//

import Foundation

public struct TargetConfig: Hashable {
    let hasResources: Bool
    let hasHeader: Bool = false
    let modules: Modules
}

public extension TargetConfig {
    static func hasDependencies(_ modules: Modules) -> Self {
        .init(hasResources: false, modules: modules)
    }

    static func hasResourcesAndDependencies(_ modules: Modules) -> Self {
        .init(hasResources: true, modules: modules)
    }

    static let resourcesOnly: Self = .init(hasResources: true, modules: [])

    static let `default`: Self = .init(hasResources: false, modules: [])
}
