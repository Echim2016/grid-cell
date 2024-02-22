//
//  GridItemCell.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import UIKit

final class GridItemCellViewModel {
  let title: String
  let subtitle: String
  let imageUrl: URL?
  
  init(item: GridItem) {
    self.title = item.id
    self.subtitle = item.title
    self.imageUrl = URL(string: item.thumbnailUrl)
  }
}

final class GridItemCell: UICollectionViewCell {
  
  var viewModel: GridItemCellViewModel? {
    didSet {
      updateUI()
    }
  }
  
  override init(frame _: CGRect) {
    super.init(frame: .zero)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateUI() {
    
  }

  private func setupUI() {
    
  }
}
