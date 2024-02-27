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
    
    XCTAssertEqual(mockItemsSUT.controllers[safe: validIndex]?.actions, [.cancelLoad])
  }
  
  func test_cancelItemTask_controllerNotFoundGivenInvalidIndex() {
    let mockItemsSUT = makeGridItemsSUT()
    let sut = makeSUT(items: mockItemsSUT.controllers)
    let invalidIndex = 99
    
    sut.viewModel.cancelItemTask(at: invalidIndex)
    
    XCTAssertNil(mockItemsSUT.controllers[safe: invalidIndex])
  }
  
  func test_cancelItemTask_doNothingWhenItemsBeingDisposed() {
    let mockItemsSUT = makeGridItemsSUT()
    let sut = makeSUT(items: mockItemsSUT.controllers)
    let validIndex = 0
    
    sut.viewModel.items.dispose()
    sut.viewModel.cancelItemTask(at: validIndex)
    
    XCTAssertEqual(mockItemsSUT.controllers[safe: validIndex]?.actions, [])
  }
  
  func test_preloadItemTask_successfullyGivenValidIndex() {
    let mockItemsSUT = makeGridItemsSUT()
    let sut = makeSUT(items: mockItemsSUT.controllers)
    let cell = GridItemCell()
    let validIndex = 0
    
    sut.viewModel.preloadItem(at: validIndex, cell: cell)
    
    XCTAssertEqual(mockItemsSUT.controllers[safe: validIndex]?.actions, [.setupCell, .preload])
    XCTAssertEqual(mockItemsSUT.controllers[safe: validIndex]?.cell, cell)
  }
  
  func test_preloadItemTask_controllerNotFoundGivenInvalidIndex() {
    let mockItemsSUT = makeGridItemsSUT()
    let sut = makeSUT(items: mockItemsSUT.controllers)
    let cell = GridItemCell()
    let invalidIndex = 99
    
    sut.viewModel.preloadItem(at: invalidIndex, cell: cell)
    
    XCTAssertNil(mockItemsSUT.controllers[safe: invalidIndex])
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
