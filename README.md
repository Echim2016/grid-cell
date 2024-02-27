
<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS-lightgray">
</p>

# Grid-cell

Render grid cells using local image caching strategy.


## Overview

- Built with MVVM-C pattern
- Setup UI programmatically
- Improve data loading mechanism using image caching strategy
- Load image data from local cache first and reload from remote if local loading task failed
- Apply `Composite Pattern` for local/remote image loading task
- Bind actions using `RxSwift`
- Send API requests using `Alamofire`
- Demostrate unit tests for `HomeViewModel`, `GridViewModel`, and `GridItemCellRenderController`


## Libraries
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [RxSwift](https://github.com/ReactiveX/RxSwift/tree/main)


## Requirement

- [x] Xcode 15.1.0
- [x] iOS 17 or higher.

