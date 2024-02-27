//
//  GridItemCellRenderController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

class GridItemCellRenderController {
  private(set) var cell: GridItemCell? = nil
  private let viewModel: GridItemCellViewModel
  
  init(viewModel: GridItemCellViewModel) {
    self.viewModel = viewModel
  }
  
  func setupCell(with cell: GridItemCell) {
    self.cell = cell
  }
  
  func preload() {
    viewModel.loadImage { [weak self] result in
      switch result {
      case let .success(data):
        self?.cell?.updateImage(with: data)
      case .failure:
        break
      }
    }
    cell?.updateUI(with: viewModel)
  }
  
  func cancelLoad() {
    viewModel.cancelLoadImageTask()
    cell = nil
  }
}

extension GridItemCellRenderController: Equatable {
  static func == (lhs: GridItemCellRenderController, rhs: GridItemCellRenderController) -> Bool {
    lhs.cell === rhs.cell && lhs.viewModel == rhs.viewModel
  }
}
