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
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    
    renderController.setupCell(with: cell)
    renderController.preload()
    imageLoader.completeRequestOnFailure(at: 0)
    
    XCTAssertNil(renderController.cell?.renderedImage)
    XCTAssertEqual(renderController.cell?.renderedMainText, viewModel.title)
    XCTAssertEqual(renderController.cell?.renderedSubtitleText, viewModel.subtitle)
  }
  
  func test_cancelLoad_releaseTaskAndCellAfterTaskCancelled() {
    let imageLoader = GridImageLoaderSpy()
    let item = makeGridItem()
    let task = TaskSpy()
    let viewModel = GridItemCellViewModel(item: item, imageLoader: imageLoader)
    viewModel.task = task
    let cell = GridItemCell()
    let renderController = GridItemCellRenderControllerSpy(viewModel: viewModel)
    
    renderController.setupCell(with: cell)
    renderController.cancelLoad()
    
    XCTAssertNil(viewModel.task)
    XCTAssertNil(renderController.cell)
    XCTAssertEqual(task.actions, [.cancel])
  }
}
