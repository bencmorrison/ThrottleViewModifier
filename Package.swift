// swift-tools-version: 6.3

import PackageDescription

let package = Package(
  name: "ThrottleViewModifier",
  platforms: [
    .macOS(.v15),
    .iOS(.v17),
    .macCatalyst(.v17),
    .watchOS(.v10),
    .tvOS(.v17),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "ThrottleViewModifier",
      targets: ["ThrottleViewModifier"]
    )
  ],
  targets: [
    .target(
      name: "ThrottleViewModifier"
    )
  ],
  swiftLanguageModes: [.v6]
)
