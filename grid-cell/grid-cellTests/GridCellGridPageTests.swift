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

// MARK: - Tests for `GridItemCellRenderController`
extension GridCellGridPageTests  {
  
  func test_setupCell_assignCellToRenderControllerSuccessfully() {
    let imageLoader = GridImageLoaderSpy()
    let item = makeGridItem()
    let viewModel = GridItemCellViewModel(item: item, imageLoader: imageLoader)
    let cell = GridItemCell()
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    
    renderController.setupCell(with: cell)
    
    XCTAssertEqual(cell, renderController.cell)
  }
  
  func test_preload_updateCellAfterImageDataLoadedSuccessfully() {
    let imageLoader = GridImageLoaderSpy()
    let item = makeGridItem()
    let viewModel = GridItemCellViewModel(item: item, imageLoader: imageLoader)
    let cell = GridItemCell()
    let anyImageData = makeAnyImageData()
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    
    renderController.setupCell(with: cell)
    renderController.preload()
    imageLoader.completeRequest(with: anyImageData, at: 0)
    
    XCTAssertEqual(renderController.cell?.renderedImage?.hashValue, anyImageData.hashValue)
    XCTAssertEqual(renderController.cell?.renderedMainText, viewModel.title)
    XCTAssertEqual(renderController.cell?.renderedSubtitleText, viewModel.subtitle)
  }
  
  func test_preload_updateCellLabelAfterImageDataLoadedOnFailure() {
    let imageLoader = GridImageLoaderSpy()
    let item = makeGridItem()
    let viewModel = GridItemCellViewModel(item: item, imageLoader: imageLoader)
    let cell = GridItemCell()
    let anyImageData = makeAnyImageData()
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    
    renderController.setupCell(with: cell)
    renderController.preload()
    imageLoader.completeRequestOnFailure(at: 0)
    
    XCTAssertNil(renderController.cell?.renderedImage)
    XCTAssertEqual(renderController.cell?.renderedMainText, viewModel.title)
    XCTAssertEqual(renderController.cell?.renderedSubtitleText, viewModel.subtitle)
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
    
    func completeRequest(with data: Data, at index: Int) {
      requests[index](.success(data))
    }
    
    func completeRequestOnFailure(at index: Int) {
      let error = NSError(domain: "request fail", code: 0)
      requests[index](.failure(error))
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
      super.setupCell(with: cell)
      actions.append(.setupCell)
    }
    
    override func preload() {
      super.preload()
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
  
  private func makeGridItem() -> GridItem {
    GridItem(id: 0, title: "Grid-0", thumbnailUrl: URL(string: RemoteAPI.baseUrl)!)
  }
  
  private func makeAnyImageData() -> Data {
    UIImage(systemName: "star")!
      .pngData()!
  }
}
