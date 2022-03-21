//
//  GenerationConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/7.
//

import Foundation

enum GenerationMode {
    case workspace
    case singleProject
}

enum LinkType {
    case staticLink
    case dynamicLink // dynamic framework will cause CombineRex and JsonValue2 to report duplicated link warning (why?
}

/// Config for Workspace or Project generation
enum GenerationConfig {
    static let mode: GenerationMode = .singleProject
    static let linkType: LinkType = .staticLink
}
