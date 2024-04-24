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
              "ViewModelImp",
              "MyLibrary"
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
            name: "ViewModel",
            targets: ["ViewModel", "ViewModelImp"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/roberthein/TinyConstraints", .upToNextMajor(from: "4.0.1")),

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
            ],
            path: "Repository/Interface"
        ),
        .target(
            name: "RepositoryImp",
            dependencies: [
                "Model",
                "Repository",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "Repository/Implementation"
        ),
        .target(
            name: "MyLibrary",
            dependencies: [
                "Model",
                "Repository",
                "RepositoryImp", // Temporal Import
                "ViewModel",
                "ViewModelImp",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxDataSources", package: "RxDataSources"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "TinyConstraints", package: "TinyConstraints"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"]
        ),
        .target(
            name: "ViewModel",
            dependencies: [
                "Model",
                "Repository",
                .product(name: "RxDataSources", package: "RxDataSources"),
            ],
            path: "ViewModel/Interface"
        ),
        .target(
            name: "ViewModelImp",
            dependencies: [
                "Model",
                "Repository",
                "ViewModel",
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "ViewModel/Implementation"
        ),
    ]
)
