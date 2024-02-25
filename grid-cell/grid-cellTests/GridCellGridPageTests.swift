//
//  GridCellGridPageTests.swift
//  grid-cellTests
//
//  Created by Yi-Chin Hsu on 2024/2/25.
//

import Foundation
import XCTest
import RxTest
@testable import grid_cell

final class GridCellGridPageTests: XCTestCase {
 
  func test_loadItems_deliverControllersAfterGridItemsLoadedSuccessfully() {
    let gridLoader = GridLoaderSpy()
    let imageLoader = GridImageLoaderSpy()
    let viewModel = GridViewModel(gridLoader: gridLoader, imageLoader: imageLoader)
    let mockItems = getMockGridItems()
    let controllers = mockItems
      .map {
        GridItemCellRenderController(
          viewModel: GridItemCellViewModel(item: $0, imageLoader: imageLoader)
        )
      }
    let testScheduler = TestScheduler(initialClock: 0)
    let testObserver = testScheduler.createObserver([GridItemCellRenderController].self)
    
    viewModel.items
      .subscribe(testObserver)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.loadItems()
    gridLoader.completeRequest(with: mockItems, at: 0)
    
    XCTAssertEqual(
      testObserver.events,
      [
        .next(0, []),
        .next(0, controllers)
      ]
    )
  }
  
  func getMockGridItems() -> [GridItem] {
    [
      GridItem(id: 0, title: "Grid-0", thumbnailUrl: URL(string: RemoteAPI.baseUrl)!),
      GridItem(id: 1, title: "Grid-1", thumbnailUrl: URL(string: RemoteAPI.baseUrl)!),
    ]
  }
}

extension GridCellGridPageTests {
  final class GridLoaderSpy: GridLoader {
    var requests: [(GridLoader.Result) -> Void] = []
    
    func load(completion: @escaping (GridLoader.Result) -> Void) {
      requests.append(completion)
    }
    
    func completeRequest(with items: [GridItem], at index: Int) {
      requests[index](.success(items))
    }
  }
  
  final class GridImageLoaderSpy: GridImageDataLoader {
    var requests: [(GridImageDataLoader.Result) -> Void] = []

    func loadImageData(
      from url: URL,
      completion: @escaping (GridImageDataLoader.Result) -> Void
    ) -> CancellableTask? {
      requests.append(completion)
      return nil
    }
  }
}
