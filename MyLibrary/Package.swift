// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LocalLibrary",
            targets: [
                "Model",
                "Repository",
                "RepositoryImp",
                "ViewModel",
                "View",
            ]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
        .library(
            name: "Repository",
            targets: ["Repository", "RepositoryImp"]
        ),
        .library(
            name: "View",
            targets: ["View"]
        ),
        .library(
            name: "ViewModel",
            targets: ["ViewModel"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/roberthein/TinyConstraints", .upToNextMajor(from: "4.0.1")),
        .package(url: "https://github.com/ccgus/fmdb", .upToNextMinor(from: "2.7.8")),
    ],

    targets: [
        .target(
            name: "Model",
            path: "Model"
        ),
        .target(
            name: "Repository",
            dependencies: [
                "Model",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "FMDB", package: "FMDB")
            ],
            path: "Repository/Interface"
        ),
        .target(
            name: "RepositoryImp",
            dependencies: [
                "Model",
                "Repository",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "FMDB", package: "FMDB")
            ],
            path: "Repository/Implementation"
        ),
        .target(
            name: "View",
            dependencies: [
                "Common",
                "Model",
                "Repository",
                "ViewModel",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxDataSources", package: "RxDataSources"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "TinyConstraints", package: "TinyConstraints"),
                .product(name: "FMDB", package: "FMDB")
            ],
            path: "View"
        ),
        .target(
            name: "ViewModel",
            dependencies: [
                "Common",
                "Model",
                "Repository",
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxDataSources", package: "RxDataSources"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "ViewModel"
        ),
        .target(
            name: "Common",
            path: "Common"
        ),
    ]
)
