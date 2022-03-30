# SwiftUI template for Tuist
[Tuist](https://github.com/tuist/tuist) is a great tool to manage Swift projects.
But I still have to write a lot of codes to config my project.
So I decide to share my configuration. `SwiftUItemplate` is my opionionated configuration for `Tuist`.

## Install

1. create your first project by `tuist init --platform ios`
2. open `Tuist/Config.swift`, change it to
```swift
import ProjectDescription

let config = Config(
    plugins: [
        .git(url: "https://github.com/haifengkao/SwiftUITemplate", tag: "0.5.0")
    ]
)
```
3. run `tuist fetch` in terminal to download `SwiftUITemplate`

If the above procedure doesn't work, please check [Tuist documentation](https://docs.tuist.io/plugins/using-plugins) for more info.

## Usage

`SwiftUITemplate` follows [microfeature architecture](https://alexanderweiss.dev/blog/2022-01-12-scale-up-your-app-with-microfeatures).

An app is composed by **mutiple microfeatures**. Each `microfeature` contains

* example target to deomstrate the feature
* unit test target to test the feature
* framework codes which implements the feature

A `module` might be `microfeature` or a swift package (Cocoapods and Carthage are not supported, PR welcome).

To add a microfeature, create `Tuist/ProjectDescriptionHelpers/Modules.swift`.
Then add the microfeature to `modules`, e.g.
```swift
import ProjectDescription
import SwiftUITemplate
private extension Module {
    static var MyApp: Module {
        .uFeature(name: "MyApp", targets: [
            .exampleApp: .resourcesOnly,
            .unitTests: .default,
            .framework: .default,
        ])
    }
}

public let modules: [Module] = [
    Module.MyApp,
    Module.Quick,
    Module.Nimble,
]
```

#### RequiredTargetType
You can specify 4 different kinds of targets:
* `.framework` the framework codes which other modules can depend on
* `.unitTests` the unit test target to test the framework
* `.exampleApp` the example target
* `.uiTests` the ui test target which will run over example app

#### TargetConfig
`TargetConfig` has four modes

* `.default` indicates the target has no resources to include and no dependencies to other modules
* `.resourcesOnly` indicates the target has resources but no dependencies
* `.hasDependencies([Modules])` let you specify the target's dependencies
* `.hasResourcesAndDependencies([Modules])` indicates the target has resources and dependencies

#### Default Swift Packages
By default, `SwiftUITemplate` uses [Nimble](https://github.com/Quick/Nimble) and [Quick](https://github.com/Quick/Quick) as the unit test framework. It's mandatory to include `Nimble` and `Quick` for the unit test placeholder codes to compile

#### Project Setting
You can specify project name and the targets in `Project.swift`.
```swift
import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let project: Project = Project(name: "MyApp",
                               organizationName: "example.SwiftUITemplate",
                               targets: modules.allProjectTargets)
```

`modules.allProjectTargets` tells `tuist` to include all targets(exampleApp, unit test, frameworks) into the generated project.

#### Dependency Management
To include swift packages, we can create a swift package with `.package`.
The following example adds `Alamofire` into `MyApp`'s framework traget.
```swift
import ProjectDescription
import SwiftUITemplate
private extension Module {
    static var MyApp: Module {
        .uFeature(name: "MyApp", targets: [
            .exampleApp: .resourcesOnly,
            .unitTests: .default,
            .framework: .hasDependencies([
                .Alamofire
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
```

We don't have to add `Module.Alamofire` into `modules` because `SwiftUITemplate` will automatically find `Module.Alamofire` in `Module.MyApp`'s dependencies.

`Tuist` requires us to specify swift packages in `Dependencies.swift`.
So we have to create `Tuist/Dependencies.swift` with the following content
```swift
import ProjectDescription
import ProjectDescriptionHelpers
import SwiftUITemplate

let dependencies = Dependencies(
    swiftPackageManager: .init(
        modules.allSwiftPacakges,
        targetSettings: modules.allTargetSettings
    ),

    platforms: [.iOS]
)
```

`SwiftUITemplate` will find out all swift packages defined in `modules` and its dependencies.

To generate the `.xcworkspace`
1. run `tuist fetch` to download swift packages
2. run `tuist generate` to generate xcworkspace

If the above procedure doesn't work, please check [Tuist tutorial](https://docs.tuist.io/tutorial/get-started) for more info.


## File structure
```

├── Tuist
│   └── (Tuist setting files)
└── Features
    ├── MyApp
    │	├── Example (example target codes)
    │   ├── Tests  (unit test target codes)
    │	└── Sources (framework codes)
    └── MyFeature1
        ├── Example
        ├── Tests
        └── Sources
```
All features are located in `Features` folder. `SwiftUITemplate` will find corresponding codes and resources in the predefined subfolders.

This plugin provides templates to create a microfeature placeholder files

```bash
tuist scaffold ufeature --name MyFeature1 --company TuistDemo
```
It will create `MyFeature1` in `Features` folder.

## Contribute

To start working on the project, you can follow the steps below:
1. Clone the project.
2. cd `fixtures/Example1`
3. `tuist fetch` to install the plugin
3. `tuist edit` to add new modules or modify the plugin files
4. `tuist generate` to generate the example xcworkspace
