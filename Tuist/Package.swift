// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  // Customize the product types for specific package product
  // Default is .staticFramework
  // productTypes: ["Alamofire": .framework,] 
  productTypes: [:]
)
#endif

let package = Package(
  name: "Haruby-iOS",
  dependencies: [
    .package(
      url: "https://github.com/airbnb/lottie-ios.git",
      from: "4.5.0"
    )
  ]
)
