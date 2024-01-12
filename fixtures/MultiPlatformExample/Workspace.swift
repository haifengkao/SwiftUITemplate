import ProjectDescription
import SwiftUITemplate

let workspace = {
    GenerationConfig.default.mode = .multipleProjects

    Workspace(name: "MultiPlatformApp", projects: [
        "Projects/iosProject",
        "Projects/macOSProject",
    ])
}()