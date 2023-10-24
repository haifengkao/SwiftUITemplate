## update FakeTarget.swift
need to align with the latest `Target.swift` definition

1. copy the latest `tuist/Sources/ProjectDescription/Target.swift` to Sourcery/FakeTarget.swift
1. `cd Sourcery`
1. `sourcery --sources FakeTarget.swift --templates AutoLenses.stencil --output ../ProjectDescriptionHelpers/generated`