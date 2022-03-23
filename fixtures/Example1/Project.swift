import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = {
    GenerationConfig.default.platform = platform

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: modules.allProjectTargets)
}()
