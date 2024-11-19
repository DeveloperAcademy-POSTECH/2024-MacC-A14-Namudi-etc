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
          "CFBundleShortVersionString": "1.0.1",
          "UIUserInterfaceStyle": "Light",
          "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
          ],
          "LSApplicationCategoryType": "public.app-category.finance",
          "UILaunchStoryboardName": "LaunchScreen",
        ]
      ),
      sources: ["Harubee-iOS/Sources/**"],
      resources: ["Harubee-iOS/Resources/**"],
      dependencies: [
        .external(name: "Lottie")
      ]
    )
  ]
)
