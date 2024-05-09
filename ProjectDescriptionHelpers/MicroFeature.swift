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

    /// tuist 4.0 has destinations check
    /// e.g. Target ParentView which depends on Childview does not support the required platforms: macos.
    // The dependency on ParentView must have a dependency condition constraining to at most: ios.
    // therefore the destinations and deploymentTargets should be computed based on the dependencies
    private var _destinations: Destinations

    var destinations: Destinations {
        // compute the destinations based on the dependencies first

        moduleDependencies(types: [.framework])
            .compactMap(\.uFeature)
            .reduce(_destinations) { result, uFeature in
                result.intersection(uFeature.destinations)
            }
    }

    private var _deploymentTargets: DeploymentTargets?
    var deploymentTargets: DeploymentTargets {
        let selfDeploymentTargets = _deploymentTargets ?? GenerationConfig.default.deploymentTargets

        return moduleDependencies(types: [.framework])
            .compactMap(\.uFeature)
            .reduce(selfDeploymentTargets) { result, uFeature in
                result.intersection(uFeature.deploymentTargets) ?? GenerationConfig.default.deploymentTargets
            }
    }
}

/*
  /// A struct representing the minimum deployment versions for each platform.
 public struct DeploymentTargets : Hashable, Codable {

     /// Minimum deployment version for iOS
     public var iOS: String?

     /// Minimum deployment version for macOS
     public var macOS: String?

     /// Minimum deployment version for watchOS
     public var watchOS: String?

     /// Minimum deployment version for tvOS
     public var tvOS: String?

     /// Minimum deployment version for visionOS
     public var visionOS: String?

   /// Multiplatform deployment target
     public static func multiplatform(iOS: String? = nil, macOS: String? = nil, watchOS: String? = nil, tvOS: String? = nil, visionOS: String? = nil) -> ProjectDescription.DeploymentTargets
  */
private enum DeploymentVersion: Hashable {
    case iOS(String)
    case macOS(String)
    case watchOS(String)
    case tvOS(String)
    case visionOS(String)

    var iOS: String? {
        if case let .iOS(version) = self {
            return version
        }
        return nil
    }

    var macOS: String? {
        if case let .macOS(version) = self {
            return version
        }
        return nil
    }

    var watchOS: String? {
        if case let .watchOS(version) = self {
            return version
        }
        return nil
    }

    var tvOS: String? {
        if case let .tvOS(version) = self {
            return version
        }
        return nil
    }

    var visionOS: String? {
        if case let .visionOS(version) = self {
            return version
        }
        return nil
    }

    enum DeploymentPlatform: String, Hashable {
        case iOS
        case macOS
        case watchOS
        case tvOS
        case visionOS
    }

    var deploymentPlatform: DeploymentPlatform {
        switch self {
        case .iOS: return .iOS
        case .macOS: return .macOS
        case .watchOS: return .watchOS
        case .tvOS: return .tvOS
        case .visionOS: return .visionOS
        }
    }
}

extension DeploymentVersion: Comparable {
    static func < (lhs: DeploymentVersion, rhs: DeploymentVersion) -> Bool {
        switch (lhs, rhs) {
        case let (.iOS(lhs), .iOS(rhs)),
             let (.macOS(lhs), .macOS(rhs)),
             let (.watchOS(lhs), .watchOS(rhs)),
             let (.tvOS(lhs), .tvOS(rhs)),
             let (.visionOS(lhs), .visionOS(rhs)):
            return lhs < rhs
        default:
            return false
        }
    }
}

private extension Set where Element == DeploymentVersion {
    var deploymentPlatform: Set<DeploymentVersion.DeploymentPlatform> {
        .init(map(\.deploymentPlatform))
    }

    // get the largest version for each platform
    var largestVersionNumberWin: Set<DeploymentVersion> {
        var dict: [DeploymentVersion.DeploymentPlatform: DeploymentVersion] = [:]
        for version in self {
            let platform = version.deploymentPlatform
            if let existing = dict[platform] {
                if version > existing {
                    dict[platform] = version
                }
            } else {
                dict[platform] = version
            }
        }
        return Set(dict.values)
    }
}

private extension DeploymentTargets {
    var versions: Set<DeploymentVersion> {
        var result: [DeploymentVersion] = []
        if let iOS = iOS {
            result.append(.iOS(iOS))
        }
        if let macOS = macOS {
            result.append(.macOS(macOS))
        }
        if let watchOS = watchOS {
            result.append(.watchOS(watchOS))
        }
        if let tvOS = tvOS {
            result.append(.tvOS(tvOS))
        }
        if let visionOS = visionOS {
            result.append(.visionOS(visionOS))
        }
        return Set(result)
    }

    static func make(from version: DeploymentVersion) -> DeploymentTargets {
        switch version {
        case let .iOS(version):
            return .iOS(version)
        case let .macOS(version):
            return .macOS(version)
        case let .watchOS(version):
            return .watchOS(version)
        case let .tvOS(version):
            return .tvOS(version)
        case let .visionOS(version):
            return .visionOS(version)
        }
    }

    static func make(from versions: Set<DeploymentVersion>) -> DeploymentTargets {
        return .multiplatform(
            iOS: versions.first { $0.iOS != nil }?.iOS,
            macOS: versions.first { $0.macOS != nil }?.macOS,
            watchOS: versions.first { $0.watchOS != nil }?.watchOS,
            tvOS: versions.first { $0.tvOS != nil }?.tvOS,
            visionOS: versions.first { $0.visionOS != nil }?.visionOS
        )
    }

    func intersection(_ other: DeploymentTargets) -> DeploymentTargets? {
        if self == other { return self }

        let platforms = versions.deploymentPlatform.intersection(other.versions.deploymentPlatform)
        let lhsVersions = versions.filter { platforms.contains($0.deploymentPlatform) }
        let rhsVersions = other.versions.filter { platforms.contains($0.deploymentPlatform) }

        // compare the versions
        let resultVersions = (lhsVersions.union(rhsVersions)).largestVersionNumberWin

        if resultVersions.count >= 2 {
            return DeploymentTargets.make(from: resultVersions)
        } else if let version = resultVersions.first {
            return DeploymentTargets.make(from: version)
        } else {
            return nil
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
