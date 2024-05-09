//
//  MicroFeature.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/4.
//

import ProjectDescription

/// micro framework
public struct MicroFeature: HasReference, Hashable {
    internal init(name: String, group: MicroFeatureGroup, requiredTargetTypes: RequiredTargetTypes, destinations: Destinations, deploymentTargets: DeploymentTargets? = nil) {
        self.name = name
        self.group = group
        self.requiredTargetTypes = requiredTargetTypes
        self.destinations = destinations
        _deploymentTargets = deploymentTargets
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

    var requiredTargetTypes: RequiredTargetTypes

    var destinations: Destinations

    private var _deploymentTargets: DeploymentTargets?
    var deploymentTargets: DeploymentTargets {
        if let target = _deploymentTargets {
            return target
        } else {
            return GenerationConfig.default.deploymentTargets
        }
    }
}

extension MicroFeature {

    func globPath(_ relativePath: String) -> ProjectDescription.Path {
        let thePath: String = "\(path)/\(relativePath)"
        switch GenerationConfig.default.mode {
        case .singleProject:
            return .relativeToManifest(thePath)
        case .workspace:
            return .relativeToManifest(thePath) // workspaces project will use path relative to it's project folder
        case .multipleProjects:
            return .relativeToRoot(thePath)
        }
    }

    func resourceGlob(_ relativePath: String)-> ProjectDescription.ResourceFileElement {
        return .glob(pattern: globPath(relativePath))
    }

    func fileListGlob(_ relativePath: String)-> ProjectDescription.FileListGlob {
        return .glob(globPath(relativePath))
    }

    func sourceGlob(_ relativePath: String)-> ProjectDescription.SourceFileGlob {
        return .glob(globPath(relativePath))
    }

    var projectPath: String {
        switch GenerationConfig.default.mode {
        case .singleProject:
            return path
        case .workspace:
            return "" // workspaces project will use path relative to it's project folder
        case .multipleProjects:
            return path
        }
    }

    var reference: TargetDependency {
        switch GenerationConfig.default.mode {
        case .workspace:
            return .project(target: name, path: .relativeToRoot(path))
        case .multipleProjects:
            return .target(name: name)
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
        makeFeatureTargets() + makeFeatureExampleTargets()
    }

    /// Helper function to create a framework target and an associated unit test target
    private func makeFeatureTargets() -> [Target] {
        let product: Product = GenerationConfig.default.linkType == .staticLink ? .staticFramework : .framework

        let resourceName: ResourceFileElements = requiredTargetTypes.hasResources(.framework) ?
            [resourceGlob("Sources/Assets/**")]
            :
            []

        let header: Headers? = requiredTargetTypes.hasHeader(.framework) ? .headers(
            public: .list([fileListGlob("Sources/PublicHeader/**")]),
            private: .list([fileListGlob("Sources/PrivateHeader/**")]),
            project: nil
        ) : nil

        let targetPostProcessor = requiredTargetTypes.targetPostProcessor(.framework)
        let sources = targetPostProcessor(.target(name: name,
                                                 destinations: destinations,
                                                 product: product,
                                                 bundleId: "io.tuist.\(name)".validBundleId,
                                                 deploymentTargets: deploymentTargets,
                                                 infoPlist: .default,
                                                 sources: [sourceGlob("Sources/**")],
                                                 resources: resourceName, // resources provided by feature, e.g. ManResources
                                                 headers: header,
                                                 dependencies: dependentReferences(types: [.framework])))

        if !requiredTargetTypes.contains(.unitTests) { return [sources] }

        let testResourceName: ResourceFileElements = requiredTargetTypes.hasResources(.unitTests) ?
            [resourceGlob("Tests/Assets/**")]
            :
            []

        let testDependencies: [TargetDependency] = [
            .target(name: name),
            .external(name: "Nimble"),
            .external(name: "Quick"),
        ] + dependentReferences(types: [.unitTests])
        let tests: Target = .target(name: "\(name)Tests",
                           destinations: destinations,
                           product: .unitTests,
                           bundleId: "io.tuist.\(name)Tests".validBundleId,
                           deploymentTargets: deploymentTargets,
                           infoPlist: .default,
                           sources: [sourceGlob("Tests/**")],
                           resources: testResourceName, // resources for testing
                           dependencies: testDependencies)
        return [sources, tests]
    }

    /// Helper function to create the application target.
    private func makeFeatureExampleTargets() -> [Target] {
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
                [resourceGlob("Example/Shared/*.xcassets"), resourceGlob("Example/Assets/**")]
            :
            [resourceGlob("Example/Shared/*.xcassets")]

        let mainTarget = targetPostProcessor(Target.target(
            name: exampleName,
            destinations: destinations,
            product: .app,
            bundleId: "io.tuist.\(exampleName)".validBundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: [sourceGlob("Example/Shared/**")],
            resources: resourceName,
            dependencies: dependentReferences(types: [.exampleApp]) + [.target(name: name)] // need to reference the framework target
        ))

        var results: [Target] = [mainTarget]


        if requiredTargetTypes.contains(.uiTests) {
            let uiTests: Target = .target(name: "\(exampleName)UITests",
                    destinations: destinations,
                    product: .uiTests,
                    bundleId: "io.tuist.\(name)UITests".validBundleId,
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: [sourceGlob("Example/UITests/**")], // TODO: need to fix the path for ui tests
                    resources: [], // resources for testing (really need resources for UI testing?
                    dependencies: [.target(name: exampleName),
                                   .external(name: "Nimble"),
                                   .external(name: "Quick")]
                            + dependentReferences(types: [.uiTests]))
            results.append(uiTests)
        }

        if requiredTargetTypes.contains(.exampleAppTests) {
            let resourceName: ResourceFileElements = requiredTargetTypes.hasResources(.exampleAppTests) ?
                    [resourceGlob("Example/Tests/Assets/**")]
                    :
                    []
            let exampleAppTests: Target = .target(name: "\(exampleName)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "io.tuist.\(exampleName)Tests".validBundleId,
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: [sourceGlob("Example/Tests/Sources/**")],
                    resources: resourceName, // resources for testing
                    dependencies: [.target(name: exampleName),
                                   .external(name: "Nimble"),
                                   .external(name: "Quick")]
                            + dependentReferences(types: [.exampleAppTests]))
            results.append(exampleAppTests)
        }

        return results
    }
}

private extension String {
    /// remove _ from String
    var validBundleId: String {
        replacingOccurrences(of: "_", with: "-")
    }
}
