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
      bundleId: "etc.namudi.harubee.ios.app",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(
        with: [
          "CFBundleDisplayName": "하루비",
          "UIUserInterfaceStyle": "Light",
          "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
          ],
          "LSApplicationCategoryType": "public.app-category.finance",
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Harubee-iOS/App/Sources/**"],
      resources: ["Harubee-iOS/App/Resources/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Data"),
        .target(name: "Shared"),
        .external(name: "Lottie")
      ]
    ),
    
      .target(
        name: "Shared",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-shared",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Harubee-iOS/Shared/Sources/**"],
        resources: ["Harubee-iOS/Shared/Resources/**"],
        dependencies: []
      ),
    
      .target(
        name: "Domain",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-domain",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Harubee-iOS/Domain/Sources/**"],
        dependencies: [
          .target(name: "Shared")
        ]
      ),
    
      .target(
        name: "Data",
        destinations: [.iPhone],
        product: .framework,
        bundleId: "etc.namudi.harubee-data",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .default,
        sources: ["Harubee-iOS/Data/Sources/**"],
        dependencies: [
          .target(name: "Domain"),
          .target(name: "Shared")
        ]
      )
  ]
)
