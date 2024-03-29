//
//  GridItemCellRenderControllerTests.swift
//  grid-cellTests
//
//  Created by Yi-Chin Hsu on 2024/2/25.
//

import Foundation
import XCTest
@testable import grid_cell

final class GridItemCellRenderControllerTests: XCTestCase {
  func test_setupCell_assignCellToRenderControllerSuccessfully() {
    let (renderController, cell, _, _) = makeSUT()
    
    renderController.setupCell(with: cell)
    
    XCTAssertEqual(cell, renderController.cell)
  }
  
  func test_preload_updateCellAfterImageDataLoadedSuccessfully() {
    let (renderController, cell, viewModel, imageLoader) = makeSUT()
    let anyImageData = makeAnyImageData()

    renderController.setupCell(with: cell)
    renderController.preload()
    imageLoader.completeRequest(with: anyImageData, at: 0)
    
    XCTAssertEqual(renderController.cell?.renderedImage?.hashValue, anyImageData.hashValue)
    XCTAssertEqual(renderController.cell?.renderedMainText, viewModel.title)
    XCTAssertEqual(renderController.cell?.renderedSubtitleText, viewModel.subtitle)
  }
  
  func test_preload_updateCellLabelAfterImageDataLoadedOnFailure() {
    let (renderController, cell, viewModel, imageLoader) = makeSUT()
    
    renderController.setupCell(with: cell)
    renderController.preload()
    imageLoader.completeRequestOnFailure(at: 0)
    
    XCTAssertNil(renderController.cell?.renderedImage)
    XCTAssertEqual(renderController.cell?.renderedMainText, viewModel.title)
    XCTAssertEqual(renderController.cell?.renderedSubtitleText, viewModel.subtitle)
  }
  
  func test_cancelLoad_releaseTaskAndCellAfterTaskCancelled() {
    let (renderController, cell, viewModel, imageLoader) = makeSUT()
    let task = TaskSpy()
    viewModel.task = task
    
    renderController.setupCell(with: cell)
    renderController.cancelLoad()
    
    XCTAssertNil(viewModel.task)
    XCTAssertNil(renderController.cell)
    XCTAssertEqual(task.actions, [.cancel])
  }
}

extension GridItemCellRenderControllerTests {
  func makeSUT() -> (
    controller: GridItemCellRenderControllerSpy,
    cell: GridItemCell,
    viewModel: GridItemCellViewModel,
    imageLoader: GridImageLoaderSpy
  ) {
    let imageLoader = GridImageLoaderSpy()
    let item = makeGridItem()
    let viewModel = GridItemCellViewModel(item: item, imageLoader: imageLoader)
    let cell = GridItemCell()
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    return (renderController, cell, viewModel, imageLoader)
  }
}
