import re
import sys


def convert_swift_dependencies(input_file, output_file):
    # Regex pattern to match both types of package declarations
    pattern = r"static let \w+: Module = .package\((SwiftPackage\(name: )?\"[^\"]+\", url: \"([^\"]+)\", requirement: \.(upToNextMajor|revision|branch)\((from: )?\"([^\"]+)\"\)\)\)"

    with open(input_file, 'r') as file:
        swift_code = file.read()

    matches = re.findall(pattern, swift_code)

    output = "// swift-tools-version: 5.9\nimport PackageDescription\n"
    output += "let package = Package(\n    name: \"PackageName\",\n    dependencies: [\n"

    # Add default packages
    output += "        .package(url: \"https://github.com/Quick/Nimble\", from: \"13.0.0\"),\n"
    output += "        .package(url: \"https://github.com/Quick/Quick\", from: \"7.0.0\"),\n"

    for url, req_type, _, version in matches:
        if req_type == "upToNextMajor":
            output += f"        .package(url: \"{url}\", from: \"{version}\"),\n"
        elif req_type == "revision":
            output += f"        .package(url: \"{url}\", .revision(\"{version}\")),\n"
        elif req_type == "branch":
            output += f"        .package(url: \"{url}\", .branch(\"{version}\")),\n"

    output = output.rstrip(",\n") + "\n    ]\n)"

    with open(output_file, 'w') as file:
        file.write(output)


if len(sys.argv) != 3:
    print("Usage: python script.py <input_file_path> <output_file_path>")
    sys.exit(1)

input_file_path = sys.argv[1]
output_file_path = sys.argv[2]

convert_swift_dependencies(input_file_path, output_file_path)
