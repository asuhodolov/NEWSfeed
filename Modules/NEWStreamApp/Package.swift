// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NEWStreamApp",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        .library(
            name: "NEWStreamApp",
            targets: ["NEWStreamApp"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            exact: "6.5.0"),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxOptional",
            exact: "5.0.2")
    ],
    targets: [
        .target(
            name: "NEWStreamApp",
            dependencies: [
                "Services",
                "Articles",
                "RxSwift",
                "RxOptional",
                .product(
                    name: "RxCocoa",
                    package: "RxSwift")],
            path: "NEWStreamApp"),
        .target(
            name: "Services",
            dependencies: [
                "Networking",
                "RxSwift",
                .product(
                    name: "RxCocoa",
                    package: "RxSwift")],
            path: "Services"),
        .target(
            name: "Networking",
            dependencies: [
                "RxSwift",
                .product(
                    name: "RxCocoa",
                    package: "RxSwift")],
            path: "Networking"),
        .target(
            name: "Articles",
            dependencies: [
                "Services",
                "RxSwift",
                "RxOptional",
                .product(
                    name: "RxCocoa",
                    package: "RxSwift")],
            path: "Stories/Articles"),
    ]
)
