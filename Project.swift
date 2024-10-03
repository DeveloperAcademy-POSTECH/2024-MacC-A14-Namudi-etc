import ProjectDescription

let project = Project(
    name: "Haruby-iOS",
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    targets: [
        .target(
            name: "Haruby-iOS",
            destinations: [.iPhone],
            product: .app,
            bundleId: "io.tuist.Haruby-iOS",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "하루비",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["Haruby-iOS/Sources/**"],
            resources: ["Haruby-iOS/Resources/**"],
            scripts: [
                .pre(script: """
                        cp ./.scripts/pre-commit ./.git/hooks
                        """, name: "PreCommitScript")
            ],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "SnapKit"),
                .external(name: "ReactorKit"),
                .external(name: "Hero"),
                .external(name: "RealmSwift", condition: .when([.ios]))
            ]
        ),
        .target(
            name: "Haruby-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.Haruby-iOSTests",
            infoPlist: .default,
            sources: ["Haruby-iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Haruby-iOS")]
        ),
    ]
)
