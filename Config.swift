import ProjectDescription

let config = Config(
    plugins: [
        // .git(url: "https://github.com/tuist/tuist-plugin-lint", tag: "0.2.0"),
        // .git(url: "https://github.com/haifengkao/SwiftUITemplate", branch: "main"),
        .local(path: "../../../../"),
        .git(url: "https: // github.com/tuist/ExampleTuistPlugin", tag: "2.0.0"),
    ]
)
