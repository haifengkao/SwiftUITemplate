import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = {
    GenerationConfig.default.mode = .multipleProjects
    GenerationConfig.default.deploymentTargets = .init(macOS: "13.0")

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: macOSModules.allProjectTargets)
}()
