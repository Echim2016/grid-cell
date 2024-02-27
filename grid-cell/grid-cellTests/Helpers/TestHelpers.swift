//
//  TestHelpers.swift
//  grid-cellTests
//
//  Created by Yi-Chin Hsu on 2024/2/25.
//

import UIKit
import XCTest
@testable import grid_cell

extension XCTestCase {
  func makeGridItem() -> GridItem {
    GridItem(id: 0, title: "Grid-0", thumbnailUrl: makeTestUrl())
  }
  
  func makeAnyImageData() -> Data {
    UIImage(systemName: "star")!
      .pngData()!
  }
  
  func makeTestUrl() -> URL {
    URL(string: "https://test-url.com")!
  }
}

