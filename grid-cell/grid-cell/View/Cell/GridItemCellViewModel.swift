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
  
  @discardableResult
  func loadImage(completion: @escaping (GridImageDataLoader.Result) -> Void) -> CancellableTask? {
    task = imageLoader.loadImageData(from: imageUrl, completion: completion)
    return task
  }
  
  func cancelLoadImageTask() {
    task?.cancel()
    task = nil
  }
}
