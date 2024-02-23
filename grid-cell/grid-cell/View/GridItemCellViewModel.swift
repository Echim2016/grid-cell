//
//  GridItemCellViewModel.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

final class GridItemCellViewModel {
  let title: String
  let subtitle: String
  let imageUrl: URL
  let imageLoader: GridImageDataLoader
  
  init(item: GridItem, imageLoader: GridImageDataLoader) {
    self.title = "\(item.id)"
    self.subtitle = item.title
    self.imageUrl = item.thumbnailUrl
    self.imageLoader = imageLoader
  }
  
  func loadImage(completion: @escaping (GridImageDataLoader.Result) -> Void) {
    imageLoader.loadImageData(from: imageUrl, completion: completion)
  }
}
