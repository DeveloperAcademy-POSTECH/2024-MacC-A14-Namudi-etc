import ProjectDescription

let projectName = "Haruby-iOS"

// MARK: - Settings
let settings: Settings = .settings(
  base: [:],
  debug: [:],
  release: [:],
  defaultSettings: .recommended
)

// MARK: - Targets
let project = Project(
  name: "Harubee-iOS",
  organizationName: "namudiEtc",
  targets: [
    .target(
      name: "Harubee-iOS",
      destinations: .iOS,
      product: .app,
      bundleId: "etc.namudi.harubee-app",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Harubee-iOS/Sources/**"],
      resources: ["Harubee-iOS/Resources/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "DesignSystem"),
        .target(name: "Data")
      ]
    ),
    
      .target(
        name: "DesignSystem",
        destinations: .iOS,
        product: .framework,
        bundleId: "etc.namudi.harubee-designsystem",
        infoPlist: .default,
        sources: ["DesignSystem/Sources/**"],
        resources: ["DesignSystem/Resources/**"],
        dependencies: []
      ),
    
      .target(
        name: "Domain",
        destinations: .iOS,
        product: .framework,
        bundleId: "etc.namudi.harubee-domain",
        infoPlist: .default,
        sources: ["Domain/Sources/**"],
        dependencies: []
      ),
    
      .target(
        name: "Data",
        destinations: .iOS,
        product: .framework,
        bundleId: "etc.namudi.harubee-data",
        infoPlist: .default,
        sources: ["Data/Sources/**"],
        dependencies: [
          .target(name: "Domain")
        ]
      )
  ]
)
