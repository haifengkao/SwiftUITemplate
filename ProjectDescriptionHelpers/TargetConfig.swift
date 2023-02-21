//
//  TargetConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/2/3.
//

import ProjectDescription

public struct TargetConfig: Hashable {
    init(hasResources: Bool, modules: Modules, targetPostProcessor: TargetPostProcessor? = nil) {
        self.hasResources = hasResources
        self.modules = modules
        self.targetPostProcessor = targetPostProcessor
    }

    public static func == (lhs: TargetConfig, rhs: TargetConfig) -> Bool {
        lhs.hasResources == rhs.hasResources
            &&
            lhs.modules == rhs.modules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hasResources)
        hasher.combine(modules)
    }

    public typealias TargetPostProcessor = (Target) -> Target

    let hasResources: Bool
    let hasHeader: Bool = false
    let modules: Modules
    let targetPostProcessor: TargetPostProcessor?
}

public extension TargetConfig {
    func targetPostProcessor(_ postProcessor: @escaping TargetPostProcessor) -> Self {
        .init(hasResources: hasResources, modules: modules, targetPostProcessor: postProcessor)
    }
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
