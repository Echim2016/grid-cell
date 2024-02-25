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
    let sut = makeSUT()
    let mockItemsSUT = makeGridItemsSUT()
    
    let testScheduler = TestScheduler(initialClock: 0)
    let testObserver = testScheduler.createObserver([GridItemCellRenderController].self)
    
    sut.viewModel.items
      .subscribe(testObserver)
      .disposed(by: sut.viewModel.disposeBag)
    
    sut.viewModel.loadItems()
    sut.gridLoader.completeRequest(with: mockItemsSUT.items, at: 0)
    
    XCTAssertEqual(
      testObserver.events,
      [
        .next(0, []),
        .next(0, mockItemsSUT.controllers)
      ]
    )
  }
  
  func test_loadItems_deliverControllersAfterGridItemsLoadedOnFailure() {
    let sut = makeSUT()   
    let testScheduler = TestScheduler(initialClock: 0)
    let testObserver = testScheduler.createObserver([GridItemCellRenderController].self)
    
    sut.viewModel.items
      .subscribe(testObserver)
      .disposed(by: sut.viewModel.disposeBag)
    
    sut.viewModel.loadItems()
    sut.gridLoader.completeRequestOnFailure(at: 0)
    
    XCTAssertEqual(
      testObserver.events,
      [
        .next(0, []),
      ]
    )
  }
  
  func test_cancelItemTask_successfullyGivenValidIndex() {
    let mockItemsSUT = makeGridItemsSUT()
    let sut = makeSUT(items: mockItemsSUT.controllers)
    let validIndex = 0
    
    sut.viewModel.cancelItemTask(at: validIndex)
    
    XCTAssertEqual(mockItemsSUT.controllers[validIndex].actions, [.cancelLoad])
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
    
    func completeRequestOnFailure(at index: Int) {
      let error = NSError(domain: "request fail", code: 0)
      requests[index](.failure(error))
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
  
  final class GridItemCellRenderControllerSpy: GridItemCellRenderController {
    enum Action {
      case setupCell
      case preload
      case cancelLoad
    }
    
    var actions: [Action] = []
    
    override func setupCell(with cell: GridItemCell) {
      actions.append(.setupCell)
    }
    
    override func preload() {
      actions.append(.preload)
    }
    
    override func cancelLoad() {
      actions.append(.cancelLoad)
    }
  }
}

extension GridCellGridPageTests {
  private func makeSUT(
    items: [GridItemCellRenderController] = []
  ) -> (viewModel: GridViewModel, gridLoader: GridLoaderSpy) {
    let gridLoader = GridLoaderSpy()
    let imageLoader = GridImageLoaderSpy()
    let viewModel = GridViewModel(
      gridLoader: gridLoader,
      imageLoader: imageLoader,
      items: items
    )
    return (viewModel, gridLoader)
  }
  
  private func makeGridItemsSUT() -> (items: [GridItem], controllers: [GridItemCellRenderControllerSpy]) {
    let items = [
      GridItem(id: 0, title: "Grid-0", thumbnailUrl: URL(string: RemoteAPI.baseUrl)!),
      GridItem(id: 1, title: "Grid-1", thumbnailUrl: URL(string: RemoteAPI.baseUrl)!),
    ]
    let imageLoader = GridImageLoaderSpy()
    let controllers = items
      .map {
        GridItemCellRenderControllerSpy(viewModel: GridItemCellViewModel(item: $0, imageLoader: imageLoader))
      }
    
    return (items, controllers)
  }
}
