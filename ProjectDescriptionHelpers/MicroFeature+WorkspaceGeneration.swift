//
//  MicroFeature+WorkspaceGeneration.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/6.
//

import ProjectDescription

extension MicroFeature {
    /// Helper function to create the Project for this ExampleApp
    func makeProject() -> Project {
        .make(name: name + "App", packages: allPackageDescendentDependencies.map(\.package), targets: targets)
    }
}
