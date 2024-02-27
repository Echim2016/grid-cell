//
//  GridViewModel.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation
import RxSwift

final class GridViewModel {
  let gridLoader: GridLoader
  let imageLoader: GridImageDataLoader
  let disposeBag = DisposeBag()
  let items: BehaviorSubject<[GridItemCellRenderController]>

  init(
    gridLoader: GridLoader,
    imageLoader: GridImageDataLoader,
    items: [GridItemCellRenderController] = []
  ) {
    self.gridLoader = gridLoader
    self.imageLoader = imageLoader
    self.items = BehaviorSubject<[GridItemCellRenderController]>(value: items)
  }

  func loadItems() {
    gridLoader.load { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(gridItems):
        let controllers = gridItems.map {
          GridItemCellRenderController(viewModel: GridItemCellViewModel(item: $0, imageLoader: self.imageLoader))
        }
        self.items.onNext(controllers)
      case let .failure(error):
        print(error)
      }
    }
  }

  func preloadItem(at index: Int, cell: GridItemCell) {
    guard let controller = getController(index: index) else { return }
    controller.setupCell(with: cell)
    controller.preload()
  }

  func cancelItemTask(at index: Int) {
    guard let controller = getController(index: index) else { return }
    controller.cancelLoad()
  }

  private func getController(index: Int) -> GridItemCellRenderController? {
    do {
      let items = try items.value()
      return items[safe: index]
    } catch {
      return nil
    }
  }
}
