
import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let dependencies = Dependencies(
    swiftPackageManager: .init(
        modules.allSwiftPackages,

        targetSettings: modules.allTargetSettings
    ),

    platforms: [platform]
)
