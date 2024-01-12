import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = {
    GenerationConfig.default.mode = .multipleProjects
    GenerationConfig.default.deploymentTargets = .init(iOS: "13.0")

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: iosModules.allProjectTargets)
}()
