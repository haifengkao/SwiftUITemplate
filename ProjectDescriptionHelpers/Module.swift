//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/2.
//

import ProjectDescription

public typealias Modules = Set<Module>

extension Modules {
    static func + (_ lhs: Self, _ rhs: Self) -> Self {
        lhs.union(rhs)
    }
}

/// Enum that defines the possible types of Frameworks
/// https://betterprogramming.pub/customize-your-xcodeproject-with-tuist-6fc41fb59262
public enum Module: Hashable {
    /// micro feature, the module with example project, and unit test
    case uFeature(MicroFeature)
    case package(SwiftPackage)

    public var package: SwiftPackage? {
        if case let .package(info) = self {
            return info
        }
        return nil
    }

    public var uFeature: MicroFeature? {
        if case let .uFeature(info) = self {
            return info
        }
        return nil
    }

    public var project: Project {
        fatalError("\(self) project not implemented")
    }

    public var projectPath: Path {
        if let code = uFeature {
            return .path(code.projectPath)
        }

        fatalError("\(self) project not implemented")
    }
}

public extension Module {
    static func uFeature(name: String,
                         group: MicroFeatureGroup = nil,
                         targets: [RequiredTargetType: TargetConfig],
                         destinations: Destinations = [.iPhone, .iPad, .mac],
                         deploymentTargets: DeploymentTargets? = nil) -> Self
    {
        .uFeature(.init(name: name,
                        group: group,
                        requiredTargetTypes: .init(configs: targets),
                        destinations: destinations,
                        deploymentTargets: deploymentTargets))
    }

    static func package(name: String, url: String, requirement: Package.Requirement) -> Self {
        .package(.init(name: name, url: url, requirement: requirement))
    }
}
