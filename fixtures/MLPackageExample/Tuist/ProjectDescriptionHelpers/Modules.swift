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
            .exampleApp: .resourcesOnly.targetPostProcessor { target in
                let existingSources: [ProjectDescription.SourceFileGlob] = target.sources?.globs ?? []
                let mlModelGlob: ProjectDescription.SourceFileGlob = .glob(.relativeToManifest("Features/MyApp/Example/MLModel/*.mlpackage"), compilerFlags: "--encrypt Features/MyApp/Example/MLModel/MNISTClassifier.mlmodelkey")
                let updatedSources = SourceFilesList.sourceFilesList(globs: existingSources + [mlModelGlob])
                
                return target
                    |> Target.lens.productName .~ "MyApp1"
                    |> Target.lens.sources .~ updatedSources
            },
            .unitTests: .default,
            .exampleAppTests: .resourcesOnly,
            .framework: .hasDependencies([
                .Alamofire,
                .MyFeature1,
                .MyInfrastructureCode,
            ]),
        ])
    }

    static var MyFeature1: Module {
        .uFeature(name: "MyFeature1", targets: [
            .exampleApp: .default,
            .unitTests: .default,
            .framework: .hasDependencies([
            ]).targetPostProcessor { target -> Target in
                target |> Target.lens.coreDataModels .~ [.coreDataModel(.relativeToManifest(
                    "Features/MyFeature1/CoreData/DummyModel.xcdatamodeld"))]
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
    Module.MyApp,
    Module.Quick,
    Module.Nimble,
]

public let destinations: Destinations = [.iPad, .iPhone]

enum MicroFeatureGroup: String {
    case infrastructure = "Infrastructure"
    case applicationServices = "ApplicationServices"
    case utilities = "Utilities"
    case common = "Common"
}
