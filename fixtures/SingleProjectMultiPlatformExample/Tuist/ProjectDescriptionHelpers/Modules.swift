//
//  Modules.swift
//  Manifests
//
//  Created by Hai Feng Kao on 2022/3/22.
//

import ProjectDescription
import SwiftUITemplate

private extension Module {
    static var MyiOSApp: Module {
        .uFeature(name: "MyiOSApp", targets: [
            .exampleApp: .resourcesOnly.targetPostProcessor { t -> Target in

                t |> Target.lens.name .~ "MyApp1"
            },
            .unitTests: .default,
            .framework: .hasDependencies([
                .Alamofire,
                .MyFeature1,
                .MyInfrastructureCode,
            ]),
        ],
        destinations: [.iPhone, .iPad],
        deploymentTargets: .init(iOS: "15.0"))
    }

    static var MyMacOSApp: Module {
        .uFeature(name: "MyMacOSApp", targets: [
            .exampleApp: .resourcesOnly.targetPostProcessor { t -> Target in

                t |> Target.lens.name .~ "MyApp1"
            },
            .unitTests: .default,
            .framework: .hasDependencies([
                .Alamofire,
                .MyFeature1,
                .MyInfrastructureCode,
            ]),
        ],
        destinations: [.mac],
        deploymentTargets: .init(macOS: "11.0"))
    }

    static var MyFeature1: Module {
        .uFeature(name: "MyFeature1", targets: [
            .exampleApp: .default,
            .unitTests: .default,
            .framework: .hasDependencies([
            ]).targetPostProcessor { target -> Target in
                // the CoreData model is Features folder
                // we have to use relativeToRoot
                target |> Target.lens.coreDataModels .~ [.init(.relativeToRoot("Features/MyFeature1/CoreData/DummyModel.xcdatamodeld"))]
                    |> Target.lens.settings .~ .settings(configurations:
                        [
                            .debug(name: "Debug", xcconfig: nil),
                            .release(name: "Release", xcconfig: nil),

                            .release(name: "Profile2", settings: ["OTHER_SWIFT_FLAGS": "$(inherited) -DProfile"], xcconfig: nil),
                        ], defaultSettings: .recommended)
            },

        ])
    }

    /// hierarchical feature directory
    static var MyInfrastructureCode: Module {
        .uFeature(name: "MyInfrastructureCode",
                  group: MicroFeatureGroup.infrastructure.rawValue,
                  targets: [
                      .exampleApp: .default,
                      .unitTests: .default,
                      .framework: .hasDependencies([
                      ]),
                  ])
    }

    static let Alamofire: Module = .package(SwiftPackage(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.5.0")))

    static var Quick: Module {
        .package(.init(name: "Quick", url: "https://github.com/Quick/Quick", requirement: .upToNextMajor(from: "6.0.1")))
    }

    static var Nimble: Module {
        .package(.init(name: "Nimble", url: "https://github.com/Quick/Nimble", requirement: .upToNextMajor(from: "11.2.1")))
    }
}

public let modules: [Module] = [
    Module.MyiOSApp,
    Module.MyMacOSApp,
    Module.Quick,
    Module.Nimble,
]

enum MicroFeatureGroup: String {
    case infrastructure = "Infrastructure"
    case applicationServices = "ApplicationServices"
    case utilities = "Utilities"
    case common = "Common"
}
