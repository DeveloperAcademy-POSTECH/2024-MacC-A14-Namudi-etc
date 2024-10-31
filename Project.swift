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
  options: .options(
    defaultKnownRegions: ["ko"],
    developmentRegion: "ko",
    textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
  ),
  targets: [
    .target(
      name: "Harubee-iOS",
      destinations: [.iPhone],
      product: .app,
      bundleId: "etc.namudi.harubee-app",
      deploymentTargets: .iOS("17.0"),
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
        .target(name: "Data"),
        .target(name: "Core")
      ]
    ),
    
      .target(
        name: "Core",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-core",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Core/Sources/**"],
        dependencies: []
      ),
    
      .target(
        name: "DesignSystem",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-designsystem",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["DesignSystem/Sources/**"],
        resources: ["DesignSystem/Resources/**"],
        dependencies: []
      ),
    
      .target(
        name: "Domain",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-domain",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Domain/Sources/**"],
        dependencies: [
          .target(name: "Core")
        ]
      ),
    
      .target(
        name: "Data",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-data",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Data/Sources/**"],
        dependencies: [
          .target(name: "Domain"),
          .target(name: "Core")
        ]
      )
  ]
)
