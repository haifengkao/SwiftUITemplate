
import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let dependencies = Dependencies(
    swiftPackageManager: .init(
        targetSettings: iosModules.allTargetSettings
    )
)
