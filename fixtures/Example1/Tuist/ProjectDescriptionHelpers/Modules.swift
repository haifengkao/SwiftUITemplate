//
//  Modules.swift
//  Manifests
//
//  Created by Hai Feng Kao on 2022/3/22.
//

import ProjectDescription
import SwiftUITemplate

private extension Module {
    static var MyApp: Module {
        .uFeature(name: "MyApp", targets: [
            .exampleApp: .resourcesOnly.targetPostProcessor { t -> Target in

                t |> Target.lens.name .~ "MyApp1"
            },
            .unitTests: .default,
            .framework: .hasDependencies([
                .Alamofire,
                .MyFeature1,
                .MyInfrastructureCode,
            ]),
        ])
    }

    static var MyFeature1: Module {
        .uFeature(name: "MyFeature1", targets: [
            .exampleApp: .resourcesOnly,
            .unitTests: .default,
            .framework: .hasDependencies([
            ]).targetPostProcessor { target -> Target in
                target |> Target.lens.coreDataModels .~ [.init(.relativeToManifest(
                    "Features/MyFeature1/CoreData/DummyModel.xcdatamodeld"))]
                    |> Target.lens.settings .~ .settings(configurations:
                        [
                            .debug(name: "Debug", xcconfig: nil),
                            .release(name: "Release", xcconfig: nil),

                            .release(name: "Profile2", settings: ["OTHER_SWIFT_FLAGS": "$(inherited) -DProfile"], xcconfig: nil),
                        ], defaultSettings: .recommended )
            },

        ])
    }

    /// hierarchical feature directory
    static var MyInfrastructureCode: Module {
        .uFeature(name: "MyInfrastructureCode",
                  group: MicroFeatureGroup.infrastructure.rawValue,
                  targets: [
                      .exampleApp: .resourcesOnly,
                      .unitTests: .default,
                      .framework: .hasDependencies([
                      ]),
                  ])
    }

    static var Alamofire: Module {
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.5.0"))
    }
}

public let modules: [Module] = [
    Module.MyApp,
    Module.Quick,
    Module.Nimble,
]

public let platform: Platform = .iOS

enum MicroFeatureGroup: String {
    case infrastructure = "Infrastructure"
    case applicationServices = "ApplicationServices"
    case utilities = "Utilities"
    case common = "Common"
}
