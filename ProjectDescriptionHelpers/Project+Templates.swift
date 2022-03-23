import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Array: HasAllPackageDescendentDependency where Element == Module {
    var allPackageDescendentDependencies: SwiftPackages {
        reduce(into: SwiftPackages()) { partialResult, module in
            partialResult = partialResult.union(module.allPackageDescendentDependencies)
        }
    }

    public var allSwiftPacakges: [Package] {
        allPackageDescendentDependencies.map(\.package)
    }

    public var allTargetSettings: TargetSetting {
        let targetSettings = allPackageDescendentDependencies.map(\.targetSetting)

        return targetSettings.reduce(into: [:]) { partialResult, targetSetting in
            partialResult.merge(targetSetting) { _, _ in
                fatalError("should not have duplicated target name")
                // return lhs
            }
        }
    }
}

extension Array: HasAllProjectTargets where Element == Module {
    public var allProjectTargets: [Target] {
        let targets = reduce(into: []) { partialResult, module in
            partialResult += module.allProjectTargets
        }.uniques(by: \.bundleId)

        // sorted targets are easier to find in Xcode
        return targets.sorted(by: { lhs, rhs in
            lhs.name < rhs.name
        })
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
