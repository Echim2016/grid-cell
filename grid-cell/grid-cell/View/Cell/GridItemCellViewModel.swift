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
  var task: CancellableTask?
  
  init(item: GridItem, imageLoader: GridImageDataLoader) {
    self.title = "\(item.id)"
    self.subtitle = item.title
    self.imageUrl = item.thumbnailUrl
    self.imageLoader = imageLoader
    self.task = nil
  }
  
  func loadImage(completion: @escaping (GridImageDataLoader.Result) -> Void) {
    task = imageLoader.loadImageData(from: imageUrl, completion: completion)
  }
  
  func cancelLoadImageTask() {
    task?.cancel()
    task = nil
  }
}
