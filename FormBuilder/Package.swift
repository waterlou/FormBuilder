import PackageDescription

let package = Package(
  name: "FormBuilder",
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0")
  ],
  targets: [
    .target(name: "FormBuilder", dependencies: ["RxSwift", "RxCocoa"])
  ]
)
