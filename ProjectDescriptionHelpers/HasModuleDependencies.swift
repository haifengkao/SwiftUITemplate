//
//  HasModuleDependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by Hai Feng Kao on 2022/2/14.
//

import Foundation

protocol HasModuleDependencies {
    func moduleDependencies(types: TargetTypes) -> Modules
}
