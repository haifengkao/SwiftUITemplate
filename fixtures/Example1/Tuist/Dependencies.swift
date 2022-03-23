
import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let dependencies = Dependencies(
    swiftPackageManager: .init(
        modules.allSwiftPacakges,

        targetSettings: modules.allTargetSettings
    ),

    platforms: [platform]
)
