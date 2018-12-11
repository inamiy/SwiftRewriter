// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftRewriter",
    products: [
        .library(
            name: "SwiftRewriter",
            targets: ["SwiftRewriter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/inamiy/swift-syntax.git", .branch("add-gyb-generated-files")),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "2.2.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "swift-rewriter",
            dependencies: ["SwiftRewriter", "Commandant", "Curry", "Files"]),
        .target(
            name: "SwiftRewriter",
            dependencies: ["SwiftSyntax"]),
        .testTarget(
            name: "SwiftRewriterTests",
            dependencies: ["SwiftRewriter", "SnapshotTesting"],
            exclude: [
                "Combined/__TestSources__",
                "Combined/__Snapshots__"
            ]),
    ]
)
