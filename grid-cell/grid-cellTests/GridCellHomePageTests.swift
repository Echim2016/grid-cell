//
//  GridCellHomePageTests.swift
//  grid-cellTests
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import XCTest
@testable import grid_cell

final class GridCellHomePageTests: XCTestCase {

  func test_homePage_navigationBarTitle() {
    let viewModel = HomeViewModel()
    let homeViewController = HomeViewController(
      viewModel: viewModel,
      coordinator: nil
    )
    homeViewController.loadViewIfNeeded()
    
    XCTAssertEqual(homeViewController.title, viewModel.navigationBarTitle)
  }
  
  func test_homePage_mainButtonTitle() {
    let viewModel = HomeViewModel()
    let homeViewController = HomeViewController(
      viewModel: viewModel,
      coordinator: nil
    )
    homeViewController.loadViewIfNeeded()
    
    XCTAssertEqual(homeViewController.mainButton.title(for: .normal), viewModel.buttonTitle)
  }
  
  func test_coordinator_navigateToGridPageCalledWhenMainButtonTapped() {
    let viewModel = HomeViewModel()
    let rootNavigationController = UINavigationController()
    let coordinator = MainCoordinatorSpy(navigationController: rootNavigationController)
    coordinator.start()
    
    guard let homeViewController = rootNavigationController.topViewController as? HomeViewController else {
      XCTFail("HomeViewController not found")
      return
    }
    
    homeViewController.loadViewIfNeeded()
    homeViewController.mainButton.sendActions(for: .touchUpInside)
    
    XCTAssertEqual(coordinator.actions, [.start, .navigateToGridPage])
  }
  
  final class MainCoordinatorSpy: MainCoordinator {
    enum Action {
      case start
      case navigateToGridPage
    }
    
    var actions: [Action] = []
    
    override func start() {
      super.start()
      actions.append(.start)
    }
    
    override func navigateToGridPage() {
      super.navigateToGridPage()
      actions.append(.navigateToGridPage)
    }
  }
}
