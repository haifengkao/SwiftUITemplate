//
//  GenerationConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/7.
//

import ProjectDescription

public enum GenerationMode {
    case workspace /// make each uFeature as a project, and whole app as single workspace, TODO: broken
    /// the folder structure
    /// |-- Projects/
    ///    |-- MyiOSApp/Project.swift
    ///    |-- MyMacOSApp/Project.swift
    /// |-- Features/ (contains shared uFeatures for both iOS and macOS)
    /// |-- Tuist/
    /// |-- Workspace.swift
    /// make each uFeature as a target, a workspace which contains multiple projects
    /// useful if you want to share code between iOS and macOS
    case multipleProjects

    /// make each uFeature as a target, and whole app as single project
    /// the folder structure
    /// |-- Features/
    /// |-- Tuist/
    /// |-- Project.swift
    case singleProject
}

public enum LinkType {
    case staticLink
    case dynamicLink
}

/// Config settings for project generation
public struct GenerationConfig {
    public var mode: GenerationMode = .singleProject
    public var linkType: LinkType = .staticLink

    public var deploymentTargets: DeploymentTargets = .iOS("15.0")
    public var featuresRootPath: String = "Features/"
    public static var `default`: Self = .init()
}
