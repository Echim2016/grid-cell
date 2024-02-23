//
//  AppDelegate.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var coordinator: MainCoordinator?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let rootNavigationController = UINavigationController()
    coordinator = MainCoordinator(navigationController: rootNavigationController)
    coordinator?.start()

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()

    return true
  }
}

protocol Coordinator {
  var navigationController: UINavigationController { get set }
  func start()
}

final class MainCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let homeViewController = HomeViewController(viewModel: HomeViewModel(), coordinator: self)
    navigationController.pushViewController(homeViewController, animated: false)
  }
  
  func navigateToGridPage() {
    let client = AlamofireHTTPClient()
    let remoteGridLoader = RemoteGridLoader(path: .photos, client: client)
    
    let remoteImageLoader = RemoteGridImageDataLoader(client: client)
    let localImageLoader = LocalGridImageDataLoader(store: GridImageFileStore())
    
    let remoteImageLoaderWithCache = RemoteGridImageDataLoaderWithCache(
      remoteLoader: remoteImageLoader,
      cache: localImageLoader
    )
    
    let imageLoaderWithFallback = GridImageLoaderWithFallbackComposite(
      primaryLoader: localImageLoader,
      fallbackLoader: remoteImageLoaderWithCache
    )
    
    let gridViewController = GridViewController(
      viewModel: GridViewModel(
        gridLoader: remoteGridLoader,
        imageLoader: imageLoaderWithFallback
      )
    )
    navigationController.pushViewController(gridViewController, animated: true)
  }
}
