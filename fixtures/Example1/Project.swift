import SwiftUITemplate

import ProjectDescription

import ProjectDescriptionHelpers

let project: Project = {
    GenerationConfig.default.platform = platform

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: modules.allProjectTargets)
}()
