import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = {
    GenerationConfig.default.destinations = destinations

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: modules.allProjectTargets)
}()
