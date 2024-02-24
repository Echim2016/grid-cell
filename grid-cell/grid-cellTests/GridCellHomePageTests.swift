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
    homeViewController.viewDidLoad()
    
    XCTAssertEqual(homeViewController.title, viewModel.navigationBarTitle)
  }
  
  func test_homePage_mainButtonTitle() {
    let viewModel = HomeViewModel()
    let homeViewController = HomeViewController(
      viewModel: viewModel,
      coordinator: nil
    )
    homeViewController.viewDidLoad()
    
    XCTAssertEqual(homeViewController.mainButton.title(for: .normal), viewModel.buttonTitle)
  }
}
