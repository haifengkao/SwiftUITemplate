//
//  MicroFeature.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/4.
//

import ProjectDescription

/// micro framework
public struct MicroFeature: HasReference, Hashable {
    internal init(name: String, group: MicroFeatureGroup, requiredTargetTypes: RequiredTargetTypes) {
        self.name = name
        self.group = group
        self.requiredTargetTypes = requiredTargetTypes
    }

    internal init(name: String,
                  group: MicroFeatureGroup = .none,
                  additionalDependencies: Modules = [])
    {
        self.init(name: name, group: group, requiredTargetTypes: .init(configs: [
            .framework: .init(hasResources: false, modules: additionalDependencies),
            // .unitTests: .init(hasResources: false, modules: []), // disable unit test target by default

        ]))
    }

    // internal init(name: String,
    //              group: MicroFeatureGroup = .none,
    //              requiredTargetTypes: RequiredTargetTypes) {
    //
    //    self.name = name
    //    self.group = group
    //    self.requiredTargetTypes = requiredTargetTypes
    // }
    //
    // internal init(name: String,
    //              group: MicroFeatureGroup = .none,
    //              additionalDependencies: [Module],
    //              unitTestDependencies: [Module],
    //              requiredTargetTypes: RequiredTargetTypes = .defulatTargets) {
    //
    //    self.name = name
    //    self.group = group
    //    dependencies[.framework] = additionalDependencies
    //    dependencies[.unitTests] = unitTestDependencies
    //    self.requiredTargetTypes = requiredTargetTypes
    // }
    //
    // internal init(name: String,
    //              group: MicroFeatureGroup = .none,
    //              additionalDependencies: [Module] = [],
    //              exampleDependencies: [Module] = [],
    //              requiredTargetTypes: RequiredTargetTypes = .defulatTargets) {
    //
    //    self.name = name
    //    self.group = group
    //    dependencies[.framework] = additionalDependencies
    //    if !exampleDependencies.isEmpty {
    //        dependencies[.exampleApp] = exampleDependencies
    //    }
    //    self.requiredTargetTypes = requiredTargetTypes
    // }

    let name: String
    let group: MicroFeatureGroup
    var path: String {
        if group != .none {
            return "Projects/" + group.rawValue + "/" + name
        } else {
            return "Projects/" + name
        }
    }

    let platform: Platform = .iOS
    let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.ipad, .iphone])

    var requiredTargetTypes: RequiredTargetTypes
}

extension MicroFeature {
    var projectPath: String {
        switch GenerationConfig.mode {
        case .singleProject:
            return path
        case .workspace:
            return "" // workspace's project will use path relative to it's project folder
        }
    }

    var project: Project {
        makeProject()
    }

    var reference: TargetDependency {
        switch GenerationConfig.mode {
        case .workspace:
            return .project(target: name, path: .relativeToRoot(path))
        case .singleProject:
            return .target(name: name)
        }
    }
}

extension MicroFeature: HasModuleDependencies {
    func moduleDependencies(types: TargetTypes) -> Modules {
        requiredTargetTypes.moduleDependencies(types: types)
    }
}

extension MicroFeature {
    private func dependentReferences(types: TargetTypes) -> [TargetDependency] {
        // tuist bug workaround: if the MicroFeature indirectly depends on any SwiftPackage, we have to add it as directly dependency
        let packages = packageDescendentDependencies(types: types)
        let frameworks = moduleDependencies(types: types).compactMap(\.uFeature)

        return packages.map(\.reference) + frameworks.map(\.reference)
    }

    var targets: [Target] {
        return makeFeatureTargets(projectPath: projectPath) + makeFeatureExampleTargets(projectPath: projectPath)
    }

    /// Helper function to create a framework target and an associated unit test target
    private func makeFeatureTargets(projectPath: String) -> [Target] {
        let product: Product = GenerationConfig.linkType == .staticLink ? .staticFramework : .framework

        let resourceName: ResourceFileElements = requiredTargetTypes.hasResources(.framework) ?
            ["\(projectPath)/Targets/Sources/Assets/**"]
            :
            []

        let header: Headers? = requiredTargetTypes.hasHeader(.framework) ? .headers(
            public: "\(projectPath)/Targets/Sources/\(name)/PublicHeader/**",
            private: "\(projectPath)/Targets/Sources/\(name)/PrivateHeader/**",
            project: nil
        ) : nil
        let sources = Target(name: name,
                             platform: platform,
                             product: product,
                             bundleId: "io.tuist.\(name)".validBundleId,
                             deploymentTarget: deploymentTarget,
                             infoPlist: .default,
                             sources: ["\(projectPath)/Targets/Sources/\(name)/**"],
                             resources: resourceName, // resources provided by feature, e.g. ManResouces
                             headers: header,
                             dependencies: dependentReferences(types: [.framework]))

        if !requiredTargetTypes.contains(.unitTests) { return [sources] }

        let testResourceName: ResourceFileElements = requiredTargetTypes.hasResources(.unitTests) ?
            ["\(projectPath)/Targets/Tests/Assets/**"]
            :
            []

        let testDependencies: [TargetDependency] = [
            .target(name: name),
            .external(name: "Nimble"),
            .external(name: "Quick"),
        ] + dependentReferences(types: [.unitTests])
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "io.tuist.\(name)Tests".validBundleId,
                           deploymentTarget: deploymentTarget,
                           infoPlist: .default,
                           sources: ["\(projectPath)/Targets/Tests/**/*.swift"],
                           resources: testResourceName, // resources for testing, e.g. WebOperationContextTest
                           dependencies: testDependencies)
        return [sources, tests]
    }

    /// Helper function to create the application target.
    private func makeFeatureExampleTargets(projectPath: String) -> [Target] {
        if !requiredTargetTypes.contains(.exampleApp) { return [] } // nothing to do

        let exampleName = name + "-Example"
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
            // "UIMainStoryboardFile": "",
            // "UILaunchStoryboardName": "LaunchScreen"
        ]

        let mainTarget = Target(
            name: exampleName,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(exampleName)".validBundleId,
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(projectPath)/Targets/Example/Shared/**"],
            resources: ["\(projectPath)/Targets/Example/Shared/*.xcassets"],
            dependencies: dependentReferences(types: [.exampleApp]) + [.target(name: name)] // need to reference the framework target
        )

        if !requiredTargetTypes.contains(.uiTests) { return [mainTarget] }

        let uiTests = Target(name: "\(exampleName)Tests\(platform)",
                             platform: platform,
                             product: .uiTests,
                             bundleId: "io.tuist.\(name)UITests\(platform)".validBundleId,
                             deploymentTarget: deploymentTarget,
                             infoPlist: .default,
                             sources: ["\(projectPath)/Targets/Example/Tests \(platform)/**/*.swift"],
                             resources: [], // resources for testing, e.g. WebOperationContextTest
                             dependencies: [.target(name: exampleName),
                                            .external(name: "Nimble"),
                                            .external(name: "Quick")]
                                 + dependentReferences(types: [.uiTests]))

        return [mainTarget, uiTests]
    }
}

extension String {
    /// remove _ from String
    var validBundleId: String {
        replacingOccurrences(of: "_", with: "-")
    }
}
