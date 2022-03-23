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
            .exampleApp: .resourcesOnly,
            .unitTests: .default,
            .framework: .hasDependencies([
                .Alamofire,
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
