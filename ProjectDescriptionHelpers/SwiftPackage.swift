//
//  SwiftPackage.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/1/4.
//

import Darwin
import ProjectDescription

public typealias TargetSetting = [String: SettingsDictionary]
public typealias SwiftPackages = Set<SwiftPackage>
/// swift package
public struct SwiftPackage: HasSwiftPackage, HasReference, Hashable {
    public init(name: String, url: String, requirement: Package.Requirement, unitTestTool: Bool = false) {
        self.name = name
        self.url = url
        self.requirement = requirement
        self.unitTestTool = unitTestTool
    }

    let name: String
    let url: String
    let requirement: Package.Requirement
    let unitTestTool: Bool

    public var package: Package { .remote(url: url, requirement: requirement) }

    public var reference: TargetDependency {
        .external(name: name)
    }

    /// Quick and Nimble needs ENABLE_TESTING_SEARCH_PATH=YES to work
    public var targetSetting: TargetSetting {
        if !unitTestTool {
            return [:]
        }
        return ["\(name)": ["ENABLE_TESTING_SEARCH_PATHS": "YES"]]
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}
