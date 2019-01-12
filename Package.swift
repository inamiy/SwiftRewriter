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
        .package(url: "https://github.com/inamiy/swift-syntax.git", .branch("inamiy-swift-5.0")),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/inamiy/Curry.git", .branch("swift-4.2")),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "2.2.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.0.0"),

        // Workaround:
        // Don't use `Result 4.1.0` for avoiding Xcode build error:
        //
        // error: SWIFT_VERSION '5' is unsupported, supported versions are: 3.0, 4.0, 4.2.
        //
        // since it uses `swift-tools-version:5.0`.
        //
        // https://forums.swift.org/t/how-to-set-swift-version-5-for-recent-dev-snapshots-in-xcode-build-settings/18692
        .package(url: "https://github.com/antitypical/Result.git", .exact("4.0.1"))
    ],
    targets: [
        .target(
            name: "swift-rewriter",
            dependencies: ["SwiftRewriter", "Commandant", "Result", "Curry", "Files"]),
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
