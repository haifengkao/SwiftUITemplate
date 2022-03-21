import FileResourceGen // plugin
import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {
    static func merged(name: String, modules: [Module], additionalFiles: [FileElement]) -> Project {
        return make(name: name, packages: modules.allPackageDescendentDependencies.map(\.package), targets: modules.allProjectTargets, additionalFiles: additionalFiles)
    }

    static func make(name: String, packages: [Package], targets: [Target], additionalFiles: [FileElement] = []) -> Project {
        Project(name: name,
                organizationName: "com.howgeli",
                packages: packages,
                targets: targets.sorted(by: { lhs, rhs in
                    lhs.name < rhs.name
                }),
                additionalFiles: additionalFiles,
                resourceSynthesizers: [.fileResourceGen(["json", "zip", "data"]), .assetGen()])
    }
}

extension Array: HasAllPackageDescendentDependency where Element == Module {
    var allPackageDescendentDependencies: SwiftPackages {
        reduce(into: SwiftPackages()) { partialResult, module in
            partialResult = partialResult.union(module.allPackageDescendentDependencies)
        }
    }

    var allProjectTargets: [Target] {
        let targets = reduce(into: []) { partialResult, module in
            partialResult += module.allProjectTargets
        }.uniques(by: \.bundleId)

        return targets
    }
}

private protocol HasAllPackageDescendentDependency {
    /// the swift packages for all targets
    /// used by the final merged project only
    var allPackageDescendentDependencies: SwiftPackages {
        get
    }
}

extension MicroFeature: HasAllPackageDescendentDependency {
    var allPackageDescendentDependencies: SwiftPackages {
        let types: TargetTypes = .all

        let directSwiftPackages: SwiftPackages = packageDependencies(types: types)

        let indirectSwiftPackages = moduleDependencies(types: types).map { (m: Module) -> SwiftPackages in

            m.allPackageDescendentDependencies
        }.joined()

        return directSwiftPackages.union(SwiftPackages(indirectSwiftPackages))
    }
}

extension Module: HasAllPackageDescendentDependency {
    var allPackageDescendentDependencies: SwiftPackages {
        switch self {
        case let .uFeature(microFeature):
            return microFeature.allPackageDescendentDependencies
        case let .package(swiftPackage):
            return [swiftPackage]
        }
    }
}
