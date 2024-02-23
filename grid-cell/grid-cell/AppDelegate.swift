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

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = makeRootViewController()
    window?.makeKeyAndVisible()

    return true
  }
}

extension AppDelegate {
  private func makeRootViewController() -> UIViewController {
    UINavigationController(
      rootViewController: HomeViewController()
    )
  }
}
