// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
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
                Target(name: name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let platform = Lens<Target, ProjectDescription.Platform>(
            get: { $0.platform },
            set: { platform, target in
                Target(name: target.name, platform: platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let product = Lens<Target, ProjectDescription.Product>(
            get: { $0.product },
            set: { product, target in
                Target(name: target.name, platform: target.platform, product: product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let productName = Lens<Target, String?>(
            get: { $0.productName },
            set: { productName, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let bundleId = Lens<Target, String>(
            get: { $0.bundleId },
            set: { bundleId, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let deploymentTarget = Lens<Target, ProjectDescription.DeploymentTarget?>(
            get: { $0.deploymentTarget },
            set: { deploymentTarget, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let infoPlist = Lens<Target, ProjectDescription.InfoPlist?>(
            get: { $0.infoPlist },
            set: { infoPlist, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let sources = Lens<Target, ProjectDescription.SourceFilesList?>(
            get: { $0.sources },
            set: { sources, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let resources = Lens<Target, ProjectDescription.ResourceFileElements?>(
            get: { $0.resources },
            set: { resources, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let copyFiles = Lens<Target, [ProjectDescription.CopyFilesAction]?>(
            get: { $0.copyFiles },
            set: { copyFiles, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let headers = Lens<Target, ProjectDescription.Headers?>(
            get: { $0.headers },
            set: { headers, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let entitlements = Lens<Target, ProjectDescription.Path?>(
            get: { $0.entitlements },
            set: { entitlements, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let scripts = Lens<Target, [ProjectDescription.TargetScript]>(
            get: { $0.scripts },
            set: { scripts, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let dependencies = Lens<Target, [ProjectDescription.TargetDependency]>(
            get: { $0.dependencies },
            set: { dependencies, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let settings = Lens<Target, ProjectDescription.Settings?>(
            get: { $0.settings },
            set: { settings, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let coreDataModels = Lens<Target, [ProjectDescription.CoreDataModel]>(
            get: { $0.coreDataModels },
            set: { coreDataModels, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let environment = Lens<Target, [String: String]>(
            get: { $0.environment },
            set: { environment, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: environment, launchArguments: target.launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let launchArguments = Lens<Target, [ProjectDescription.LaunchArgument]>(
            get: { $0.launchArguments },
            set: { launchArguments, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: launchArguments, additionalFiles: target.additionalFiles)
            }
        )
        public static let additionalFiles = Lens<Target, [ProjectDescription.FileElement]>(
            get: { $0.additionalFiles },
            set: { additionalFiles, target in
                Target(name: target.name, platform: target.platform, product: target.product, productName: target.productName, bundleId: target.bundleId, deploymentTarget: target.deploymentTarget, infoPlist: target.infoPlist, sources: target.sources, resources: target.resources, copyFiles: target.copyFiles, headers: target.headers, entitlements: target.entitlements, scripts: target.scripts, dependencies: target.dependencies, settings: target.settings, coreDataModels: target.coreDataModels, environment: target.environment, launchArguments: target.launchArguments, additionalFiles: additionalFiles)
            }
        )
    }
}
