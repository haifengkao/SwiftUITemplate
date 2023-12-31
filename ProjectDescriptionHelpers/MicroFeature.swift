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
                  group: MicroFeatureGroup,
                  additionalDependencies: Modules = [])
    {
        self.init(name: name, group: group, requiredTargetTypes: .init(configs: [
            .framework: .init(hasResources: false, modules: additionalDependencies),
            // .unitTests: .init(hasResources: false, modules: []), // disable unit test target by default

        ]))
    }

    let name: String
    let group: MicroFeatureGroup

    var path: String {
        if let group = group {
            return GenerationConfig.default.featuresRootPath + group + "/" + name
        } else {
            return GenerationConfig.default.featuresRootPath + name
        }
    }

    private var _destinations: Destinations?
    var destinations: Destinations {
        if let _destinations = _destinations {
            return _destinations
        } else {
            return GenerationConfig.default.destinations
        }
    }

    private var _deploymentTargets: DeploymentTargets?
    var deploymentTargets: DeploymentTargets {
        if let target = _deploymentTargets {
            return target
        } else {
            return GenerationConfig.default.deploymentTargets
        }
    }

    var requiredTargetTypes: RequiredTargetTypes
}

extension MicroFeature {
    var projectPath: String {
        switch GenerationConfig.default.mode {
        case .singleProject:
            return path
        case .workspace:
            return "" // workspaces project will use path relative to it's project folder
        }
    }

    var reference: TargetDependency {
        switch GenerationConfig.default.mode {
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
        let product: Product = GenerationConfig.default.linkType == .staticLink ? .staticFramework : .framework

        let resourceName: ResourceFileElements = requiredTargetTypes.hasResources(.framework) ?
            ["\(projectPath)/Sources/Assets/**"]
            :
            []

        let header: Headers? = requiredTargetTypes.hasHeader(.framework) ? .headers(
            public: "\(projectPath)/Sources/PublicHeader/**",
            private: "\(projectPath)/Sources/PrivateHeader/**",
            project: nil
        ) : nil

        let targetPostProcessor = requiredTargetTypes.targetPostProcessor(.framework)
        let sources = targetPostProcessor(Target(name: name,
                                                 destinations: destinations,
                                                 product: product,
                                                 bundleId: "io.tuist.\(name)".validBundleId,
                                                 deploymentTargets: deploymentTargets,
                                                 infoPlist: .default,
                                                 sources: ["\(projectPath)/Sources/**"],
                                                 resources: resourceName, // resources provided by feature, e.g. ManResouces
                                                 headers: header,
                                                 dependencies: dependentReferences(types: [.framework])))

        if !requiredTargetTypes.contains(.unitTests) { return [sources] }

        let testResourceName: ResourceFileElements = requiredTargetTypes.hasResources(.unitTests) ?
            ["\(projectPath)/Tests/Assets/**"]
            :
            []

        let testDependencies: [TargetDependency] = [
            .target(name: name),
            .external(name: "Nimble"),
            .external(name: "Quick"),
        ] + dependentReferences(types: [.unitTests])
        let tests = Target(name: "\(name)Tests",
                           destinations: destinations,
                           product: .unitTests,
                           bundleId: "io.tuist.\(name)Tests".validBundleId,
                           deploymentTargets: deploymentTargets,
                           infoPlist: .default,
                           sources: ["\(projectPath)/Tests/**"],
                           resources: testResourceName, // resources for testing
                           dependencies: testDependencies)
        return [sources, tests]
    }

    /// Helper function to create the application target.
    private func makeFeatureExampleTargets(projectPath: String) -> [Target] {
        if !requiredTargetTypes.contains(.exampleApp) { return [] } // nothing to do

        let exampleName = name + "-Example"
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
            // "UIMainStoryboardFile": "",
            // "UILaunchStoryboardName": "LaunchScreen"
        ]

        let targetPostProcessor = requiredTargetTypes.targetPostProcessor(.exampleApp)

        // include the Assets folder as well if the example target has resources
        // Example/Shared/Assets.xcassets is the default location for the example app's assets
        let resourceName: ResourceFileElements = requiredTargetTypes.hasResources(.exampleApp) ?
                    ["\(projectPath)/Example/Shared/*.xcassets", "\(projectPath)/Example/Assets/**"]
                    :
                    ["\(projectPath)/Example/Shared/*.xcassets"]
        
        
        let mainTarget = targetPostProcessor(Target(
            name: exampleName,
            destinations: destinations,
            product: .app,
            bundleId: "io.tuist.\(exampleName)".validBundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(projectPath)/Example/Shared/**"],
            resources: resourceName,
            dependencies: dependentReferences(types: [.exampleApp]) + [.target(name: name)] // need to reference the framework target
        ))

        if !requiredTargetTypes.contains(.uiTests) { return [mainTarget] }

        let uiTests = Target(name: "\(exampleName)UITests",
                             destinations: destinations,
                             product: .uiTests,
                             bundleId: "io.tuist.\(name)UITests".validBundleId,
                             deploymentTargets: deploymentTargets,
                             infoPlist: .default,
                             sources: ["\(projectPath)/Example/UITests/**"],
                             resources: [], // resources for testing
                             dependencies: [.target(name: exampleName),
                                            .external(name: "Nimble"),
                                            .external(name: "Quick")]
                                 + dependentReferences(types: [.uiTests]))

        return [mainTarget, uiTests]
    }
}

private extension String {
    /// remove _ from String
    var validBundleId: String {
        replacingOccurrences(of: "_", with: "-")
    }
}
