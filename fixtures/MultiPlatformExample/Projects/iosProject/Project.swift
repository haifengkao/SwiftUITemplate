import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = {

    return Project(name: "App",
                   organizationName: "example.SwiftUITemplate",

                   targets: iosModules.allProjectTargets)
}()
