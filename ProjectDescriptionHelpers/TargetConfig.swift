//
//  TargetConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/2/3.
//

import Foundation

struct TargetConfig: Hashable {
    let hasResources: Bool
    let hasHeader: Bool = false
    let modules: Modules
}

extension TargetConfig {
    static func modules(_ modules: Modules) -> Self {
        .init(hasResources: false, modules: modules)
    }

    static func resourcesWithModules(_ modules: Modules) -> Self {
        .init(hasResources: true, modules: modules)
    }

    static let resourcesOnly: Self = .init(hasResources: true, modules: [])

    static let empty: Self = .init(hasResources: false, modules: [])
}
