import Foundation
import ProjectDescription
let nameAttribute: Template.Attribute = .required("name")

let defaultAuthor: String = {
    let arguments = ["config", "user.name"]

    // shell will return output with trailing \n
    let output = executeCommand(command: "/usr/bin/git", args: arguments).trimmingCharacters(in: .whitespacesAndNewlines)

    // if no git repo, we just get the system's user name
    return output != "" ? output : NSUserName()
}()

let defaultYear: String = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: Date())
}()

let defaultDate: String = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: Date())
}()

let yearAttribute: Template.Attribute = .optional("year", default: defaultYear)
let dateAttribute: Template.Attribute = .optional("date", default: defaultDate)

let authorAttribute: Template.Attribute = .optional("author", default: defaultAuthor)

let companyAttribute: Template.Attribute = .optional("company", default: "")
let rootPath = "Features"
let template = Template(
    description: "Custom template",
    attributes: [
        nameAttribute,
        authorAttribute,
        companyAttribute,
        dateAttribute,
        yearAttribute,
    ],
    items: [
        /*
         .string(
             path: "Project.swift",
             contents: "My template contents of name \(nameAttribute)"
         ),*/

        .file(
            path: "\(rootPath)/\(nameAttribute)/Example/Shared/ContentView.swift",
            templatePath: "Example/Shared/ContentView.stencil"
        ),
        .file(
            path: "\(rootPath)/\(nameAttribute)/Example/Shared/\(nameAttribute)App.swift",
            templatePath: "Example/Shared/uFeatureNameApp.stencil"
        ),
        .directory(
            path: "\(rootPath)/\(nameAttribute)/Sources/\(nameAttribute)",
            sourcePath: "Sources/uFeatureName/ReplaceMe.swift/"
        ),
        .directory(
            path: "\(rootPath)/\(nameAttribute)/Example/Shared/Assets.xcassets",
            sourcePath: "Example/Shared/Assets.xcassets"
        ),

        .file(
            path: "\(rootPath)/\(nameAttribute)/Tests/\(nameAttribute)Tests/Tests.swift",
            templatePath: "Tests/uFeatureNameTests/Tests.stencil"
        ),
    ]
)

func executeCommand(command: String, args: [String]) -> String {
    let task = Process()
    task.launchPath = command
    task.arguments = args
    let pipe = Pipe()

    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: data, as: UTF8.self)
    return output
}
