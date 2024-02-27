//
//  TestHelper+Loader.swift
//  grid-cellTests
//
//  Created by Yi-Chin Hsu on 2024/2/25.
//

import XCTest
@testable import grid_cell

extension XCTestCase {
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
      super.cancelLoad()
      actions.append(.cancelLoad)
    }
  }
  
  final class TaskSpy: CancellableTask {
    enum Action {
      case cancel
    }
    
    var actions: [Action] = []
    
    func cancel() {
      actions.append(.cancel)
    }
  }
}
