//
//  GenerationConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/7.
//

import ProjectDescription

public enum GenerationMode {
    case workspace /// make each uFeature as a project, and whole app as single workspace, TODO: broken
    case singleProject /// make each uFeature as a target, and whole app as single project
}

public enum LinkType {
    case staticLink
    case dynamicLink
}

/// Config settings for project generation
public struct GenerationConfig {
    public var mode: GenerationMode = .singleProject
    public var linkType: LinkType = .staticLink

    public var destinations: Destinations = [.iPhone, .iPad]
    public var deploymentTargets: DeploymentTargets =  DeploymentTargets(iOS: "15.0")
    public var featuresRootPath: String = "Features/"
    public static var `default`: Self = .init()
}
