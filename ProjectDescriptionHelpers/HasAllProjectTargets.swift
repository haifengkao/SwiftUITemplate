//
//  MicroFeature+ProjectGeneration.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/7.
//

import ProjectDescription

protocol HasAllProjectTargets {
    var allProjectTargets: [Target] { get }
}

extension Module: HasAllProjectTargets {
    var allProjectTargets: [Target] {
        switch self {
        case let .uFeature(microFeature):
            return microFeature.allProjectTargets
        case .package:
            return [] // swift package doesn't have targets
        }
    }
}

extension MicroFeature: HasAllProjectTargets {
    var allProjectTargets: [Target] {
        targets
            +
            allMicroFeatureDependencies.map(\.allProjectTargets).joined()
    }
}

private extension MicroFeature {
    var allMicroFeatureDependencies: [MicroFeature] {
        moduleDependencies(types: .all).compactMap(\.uFeature)
    }
}
