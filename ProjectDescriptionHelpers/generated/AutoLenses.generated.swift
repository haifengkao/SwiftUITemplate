// Generated using Sourcery 2.1.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable variable_name
import ProjectDescription

infix operator .~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

public struct Lens<whole, part> {
    let get: (whole) -> part
    let set: (part, whole) -> whole
}

public func + <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        get: { a in rhs.get(lhs.get(a)) },
        set: { c, a in lhs.set(rhs.set(c, lhs.get(a)), a) }
    )
}

public func .~ <A, B>(lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in lhs.set(rhs, a) }
}

public func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

public extension Target {
    enum lens {
        public static let name = Lens<Target, String>(
            get: { $0.name },
            set: { name, target in
                .target(name: name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let destinations = Lens<Target, Destinations>(
            get: { $0.destinations },
            set: { destinations, target in
                .target(name: target.name, destinations: destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let product = Lens<Target, Product>(
            get: { $0.product },
            set: { product, target in
                .target(name: target.name, destinations: target.destinations, product: product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let productName = Lens<Target, String?>(
            get: { $0.productName },
            set: { productName, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let bundleId = Lens<Target, String>(
            get: { $0.bundleId },
            set: { bundleId, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let deploymentTargets = Lens<Target, DeploymentTargets?>(
            get: { $0.deploymentTargets },
            set: { deploymentTargets, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let infoPlist = Lens<Target, InfoPlist?>(
            get: { $0.infoPlist },
            set: { infoPlist, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let sources = Lens<Target, SourceFilesList?>(
            get: { $0.sources },
            set: { sources, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let resources = Lens<Target, ResourceFileElements?>(
            get: { $0.resources },
            set: { resources, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let copyFiles = Lens<Target, [CopyFilesAction]?>(
            get: { $0.copyFiles },
            set: { copyFiles, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let headers = Lens<Target, Headers?>(
            get: { $0.headers },
            set: { headers, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let entitlements = Lens<Target, Entitlements?>(
            get: { $0.entitlements },
            set: { entitlements, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let scripts = Lens<Target, [TargetScript]>(
            get: { $0.scripts },
            set: { scripts, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let dependencies = Lens<Target, [TargetDependency]>(
            get: { $0.dependencies },
            set: { dependencies, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let settings = Lens<Target, Settings?>(
            get: { $0.settings },
            set: { settings, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let coreDataModels = Lens<Target, [CoreDataModel]>(
            get: { $0.coreDataModels },
            set: { coreDataModels, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let environmentVariables = Lens<Target, [String: EnvironmentVariable]>(
            get: { $0.environmentVariables },
            set: { environmentVariables, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let launchArguments = Lens<Target, [LaunchArgument]>(
            get: { $0.launchArguments },
            set: { launchArguments, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let additionalFiles = Lens<Target, [FileElement]>(
            get: { $0.additionalFiles },
            set: { additionalFiles, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let buildRules = Lens<Target, [BuildRule]>(
            get: { $0.buildRules },
            set: { buildRules, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let mergedBinaryType = Lens<Target, MergedBinaryType>(
            get: { $0.mergedBinaryType },
            set: { mergedBinaryType, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let mergeable = Lens<Target, Bool>(
            get: { $0.mergeable },
            set: { mergeable, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: mergeable, onDemandResourcesTags: target.onDemandResourcesTags)
            }
        )
        public static let onDemandResourcesTags = Lens<Target, OnDemandResourcesTags?>(
            get: { $0.onDemandResourcesTags },
            set: { onDemandResourcesTags, target in
                .target(name: target.name, destinations: target.destinations, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTargets: target.deploymentTargets, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environmentVariables: target.environmentVariables, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles, buildRules: target.buildRules, mergedBinaryType: target.mergedBinaryType, mergeable: target.mergeable, onDemandResourcesTags: onDemandResourcesTags)
            }
        )
    }
}
