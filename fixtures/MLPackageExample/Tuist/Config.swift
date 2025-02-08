import ProjectDescription

let config = Config(
    swiftVersion: "5.10",
    plugins: [
        // .git(url: "https://github.com/haifengkao/SwiftUITemplate"),
        .local(path: "../../../../"),
    ]
)
